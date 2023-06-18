/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Ensembles.Shell.Layouts {
    public class MobileLayout : Gtk.Grid {
        private unowned ArrangerWorkstation.IAWCore i_aw_core;

        private weak AssignablesBoard assignables_board;
        private weak InfoDisplay info_display;
        private weak SynthControlPanel synth_control_panel;
        private weak VoiceNavPanel voice_nav_panel;
        private weak MixerBoard mixer_board;
        private weak SamplerPadsPanel sampler_pads_panel;
        private weak StyleControlPanel style_control_panel;
        private weak RegistryPanel registry_panel;
        private weak KeyboardPanel keyboard;

        private Gtk.Grid infoview;
        private Gtk.Grid keyboardview;
        private Gtk.Box style_registry_box;
        private Gtk.Box style_controller_socket;
        private Gtk.Box registry_socket;
        private Gtk.Button start_button;

        private Gtk.ScrolledWindow scrolled_window;
        private Adw.Flap flap;
        private Gtk.Stack main_stack;

        private Gtk.ListBox menu_box;

        public signal void on_menu_show_change (bool shown);

        public MobileLayout (
            ArrangerWorkstation.IAWCore i_aw_core
        ) {
            Object (
                width_request: 812,
                height_request: 375
            );

            this.i_aw_core = i_aw_core;
        }

        public MobileLayout add_assignables_board (AssignablesBoard? assignables_board) {
            this.assignables_board = assignables_board;
            return this;
        }

        public MobileLayout add_synth_control_panel (SynthControlPanel? synth_control_panel) {
            this.synth_control_panel = synth_control_panel;
            return this;
        }

        public MobileLayout add_info_display (InfoDisplay? info_display) {
            this.info_display = info_display;
            return this;
        }

        public MobileLayout add_voice_nav_panel (VoiceNavPanel? voice_nav_panel) {
            this.voice_nav_panel = voice_nav_panel;
            return this;
        }

        public MobileLayout add_mixer_board (MixerBoard? mixer_board) {
            this.mixer_board = mixer_board;
            return this;
        }

        public MobileLayout add_sampler_pads_panel (SamplerPadsPanel? sampler_pads_panel) {
            this.sampler_pads_panel = sampler_pads_panel;
            return this;
        }

        public MobileLayout add_style_control_panel (StyleControlPanel? style_control_panel) {
            this.style_control_panel = style_control_panel;
            return this;
        }

        public MobileLayout add_registry_panel (RegistryPanel? registry_panel) {
            this.registry_panel = registry_panel;
            return this;
        }

        public MobileLayout add_keyboard (KeyboardPanel? keyboard_panel) {
            this.keyboard = keyboard_panel;
            return this;
        }

        /**
         * Builds the layout.
         */
        public MobileLayout build () {
            build_ui ();
            build_events ();
            return this;
        }

        private void build_ui () {
            flap = new Adw.Flap ();
            attach (flap, 0, 0);

            // Make menu
            menu_box = new Gtk.ListBox () {
                width_request = 200
            };
            flap.set_flap (menu_box);
            menu_box.add_css_class ("adw-listbox");

            var info_entry = new Adw.ActionRow () {
                title = "Info Display",
                subtitle = "View interactive infomation display",
                name = "info"
            };
            menu_box.append (info_entry);

            var keyboard_entry = new Adw.ActionRow () {
                title = "Keyboard",
                subtitle = "Show the keys, style control buttons and registry buttons",
                name = "keyboard"
            };
            menu_box.append (keyboard_entry);

            main_stack = new Gtk.Stack () {
                width_request = 800,
                transition_type = Gtk.StackTransitionType.SLIDE_UP_DOWN,
                transition_duration = 300
            };
            flap.set_content (main_stack);

            // Make Content
            infoview = new Gtk.Grid ();
            main_stack.add_named (infoview, "info-view");

            keyboardview = new Gtk.Grid ();
            main_stack.add_named (keyboardview, "keyboard-view");

            scrolled_window = new Gtk.ScrolledWindow () {
                height_request = 62,
                vscrollbar_policy = Gtk.PolicyType.NEVER
            };
            keyboardview.attach (scrolled_window, 0, 0);
            style_registry_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            scrolled_window.set_child (style_registry_box);

            style_controller_socket = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            style_registry_box.append (style_controller_socket);

            var start_button_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);
            start_button_box.add_css_class ("panel");
            style_registry_box.append (start_button_box);

            start_button = new Gtk.Button.from_icon_name ("media-playback-start-symbolic") {
                width_request = 64,
                height_request = 32
            };
            start_button.add_css_class (Granite.STYLE_CLASS_DESTRUCTIVE_ACTION);
            start_button.remove_css_class ("image-button");
            start_button.clicked.connect (() => {
                i_aw_core.get_style_engine ().toggle_play ();
            });

            start_button_box.append (start_button);
            start_button_box.append (new Gtk.Label (_("START/STOP")) { opacity = 0.5 });

            registry_socket = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            style_registry_box.append (registry_socket);
        }

        public void reparent () {
            assignables_board.unparent ();
            info_display.unparent ();
            synth_control_panel.unparent ();
            voice_nav_panel.unparent ();
            mixer_board.unparent ();
            sampler_pads_panel.unparent ();
            style_control_panel.unparent ();
            registry_panel.unparent ();
            keyboard.unparent ();

            infoview.attach (info_display, 0, 0);
            info_display.fill_screen = true;

            style_controller_socket.append (style_control_panel);
            registry_socket.append (registry_panel);
            keyboardview.attach (keyboard, 0, 1);
        }

        private void build_events () {
            menu_box.row_selected.connect ((row) => {
                main_stack.set_visible_child_name (row.name + "-view");
            });

            flap.notify.connect ((param) => {
                if (param.name == "reveal-flap") {
                    on_menu_show_change (flap.reveal_flap);
                    Idle.add (() => {
                        if (flap.reveal_flap && flap.folded) {
                            main_stack.add_css_class ("dimmed");
                        } else {
                            main_stack.remove_css_class ("dimmed");
                        }
                        return false;
                    });
                }
            });
        }

        public bool show_menu (bool show) {
            flap.set_reveal_flap (show);
            return !show;
        }
    }
}
