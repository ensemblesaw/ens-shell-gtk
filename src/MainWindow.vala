/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

using Ensembles.ArrangerWorkstation;

namespace Ensembles.Shell {
    public class MainWindow : Gtk.ApplicationWindow {
        private static MainWindow _instance;
        public static MainWindow instance {
            get {
                if (_instance == null) {
                    _instance = new MainWindow ();
                }

                return _instance;
            }
        }

        internal unowned IAWCore i_aw_core;

        public bool using_kiosk_layout { get; private set; }

        // Event Handling
        private Gtk.EventControllerKey event_controller_key;

        // Headerbar
        private Gtk.HeaderBar headerbar;

        // Responsive UI
        private Adw.Squeezer squeezer;
        private Gtk.ToggleButton flap_button;
        private bool flap_revealed = true;

        // Various major layouts
        private Layouts.DesktopLayout desktop_layout;
        private Layouts.MobileLayout mobile_layout;
        private Layouts.KioskLayout kiosk_layout;

        // Sub-layouts
        private Layouts.AssignablesBoard assignables_board;
        private Layouts.InfoDisplay info_display;
        private Layouts.SynthControlPanel synth_control_panel;
        private Layouts.VoiceNavPanel voice_nav_panel;
        private Layouts.MixerBoard mixer_board;
        private Layouts.SamplerPadsPanel sampler_pads_panel;
        private Layouts.StyleControlPanel style_control_panel;
        private Layouts.RegistryPanel registry_panel;
        private Layouts.KeyboardPanel keyboard;

        // Headerbar
        private Widgets.BeatVisualization beat_visualization;

        private MainWindow () {
        }

        // Builder functions
        public MainWindow for_application (Gtk.Application application) {
            this.application = application;
            return this;
        }

        public MainWindow with_arranger_workstation (IAWCore i_aw_core) {
            this.i_aw_core = i_aw_core;
            return this;
        }

        public MainWindow with_name (string name) {
            title = name;
            return this;
        }

        public MainWindow with_icon (string icon) {
            icon_name = icon;
            return this;
        }

        public MainWindow use_kiosk_layout (bool active) {
            using_kiosk_layout = active;
            return this;
        }

        construct {
            build_ui ();
            build_events ();
        }

        private void build_ui () {
            if (using_kiosk_layout) {
                decorated = false;
                fullscreened = true;

                info_display = new Layouts.InfoDisplay ();
                info_display.fill_screen = true;
                mixer_board = new Layouts.MixerBoard ();

                kiosk_layout = new Layouts.KioskLayout (info_display, mixer_board);
                set_child (kiosk_layout);
                return;
            }

            // Make headerbar
            headerbar = new Gtk.HeaderBar () {
                show_title_buttons = true,
            };

            set_titlebar (headerbar);

            flap_button = new Gtk.ToggleButton () {
                visible = false
            };
            flap_button.set_icon_name ("view-continuous-symbolic");
            flap_button.remove_css_class ("image-button");
            flap_button.clicked.connect (() => {
                flap_revealed = mobile_layout.show_menu (flap_revealed);
            });
            headerbar.pack_start (flap_button);

            beat_visualization = new Widgets.BeatVisualization ();
            headerbar.pack_start (beat_visualization);

            squeezer = new Adw.Squeezer () {
                orientation = Gtk.Orientation.VERTICAL,
                transition_type = Adw.SqueezerTransitionType.CROSSFADE,
                transition_duration = 400
            };
            set_child (squeezer);

            assignables_board = new Layouts.AssignablesBoard ();
            info_display = new Layouts.InfoDisplay ();
            synth_control_panel = new Layouts.SynthControlPanel ();
            voice_nav_panel = new Layouts.VoiceNavPanel ();
            mixer_board = new Layouts.MixerBoard ();
            sampler_pads_panel = new Layouts.SamplerPadsPanel ();
            style_control_panel = new Layouts.StyleControlPanel ();
            registry_panel = new Layouts.RegistryPanel ();
            keyboard = new Layouts.KeyboardPanel ();

            desktop_layout = new Layouts.DesktopLayout (assignables_board,
                                                        info_display,
                                                        synth_control_panel,
                                                        voice_nav_panel,
                                                        mixer_board,
                                                        sampler_pads_panel,
                                                        style_control_panel,
                                                        registry_panel,
                                                        keyboard);
            squeezer.add (desktop_layout);
            desktop_layout.reparent ();


            mobile_layout = new Layouts.MobileLayout (i_aw_core)
            .add_assignables_board (assignables_board)
            .add_info_display (info_display)
            .add_synth_control_panel (synth_control_panel)
            .add_voice_nav_panel (voice_nav_panel)
            .add_mixer_board (mixer_board)
            .add_sampler_pads_panel (sampler_pads_panel)
            .add_registry_panel (registry_panel)
            .add_keyboard (keyboard)
            .build ();
            squeezer.add (mobile_layout);
        }

        public void show_ui () {
            present ();
            show ();
        }

        private void build_events () {
            event_controller_key = new Gtk.EventControllerKey ();
            ((Gtk.Widget)this).add_controller (event_controller_key);

            event_controller_key.key_pressed.connect ((keyval, keycode, state) => {
                Console.log ("key: %u".printf (keyval));

                return false;
            });

            i_aw_core.ready.connect (() => {
                Console.log ("Arranger Workstation Initialized!", Console.LogLevel.SUCCESS);
            });

            notify["default-height"].connect (() => {
                if (!using_kiosk_layout) {
                    flap_button.visible = squeezer.get_visible_child () == mobile_layout;

                    if (squeezer.get_visible_child () == desktop_layout) {
                        desktop_layout.reparent ();
                    } else {
                        mobile_layout.reparent ();
                    }
                }
            });

            notify["maximized"].connect (() => {
                fullscreen ();
                Timeout.add (100, () => {
                    if (!using_kiosk_layout) {
                        flap_button.visible = squeezer.get_visible_child () == mobile_layout;

                        if (squeezer.get_visible_child () == desktop_layout) {
                            desktop_layout.reparent ();
                        } else {
                            mobile_layout.reparent ();
                        }
                    }
                    return false;
                });
            });

            mobile_layout.on_menu_show_change.connect ((shown) => {
                flap_revealed = !shown;
                flap_button.active = shown;
            });

            ((Gtk.Widget) this).realize.connect (() => {
                if (using_kiosk_layout) {
                    var display = Gdk.Display.get_default ();
                    var monitor = display.get_monitor_at_surface (get_surface ());
                    set_default_size (monitor.geometry.width, monitor.geometry.height);
                    kiosk_layout.width_request = monitor.geometry.width;
                    kiosk_layout.height_request = monitor.geometry.height;
                }
            });
        }
    }
 }
