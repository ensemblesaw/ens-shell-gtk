/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Ensembles.GtkShell.Layouts {
    public class DesktopLayout : Gtk.Grid, Layout {
        public unowned ArrangerWorkstation.IAWCore aw_core { private get; construct; }
        public unowned Settings settings { private get; construct; }

        public unowned AssignablesBoard assignables_board { private get; construct; }
        public unowned InfoDisplay info_display { private get; construct; }
        public unowned SynthControlPanel synth_control_panel { private get; construct; }
        public unowned VoiceNavPanel voice_nav_panel { private get; construct; }
        public unowned MixerBoard mixer_board { private get; construct; }
        public unowned SamplerPadsPanel sampler_pads_panel { private get; construct; }
        public unowned StyleControlPanel style_control_panel { private get; construct; }
        public unowned RegistryPanel registry_panel { private get; construct; }
        public unowned KeyboardPanel keyboard { private get; construct; }
        public Gtk.Button start_button;

        private Gtk.CenterBox top_row;
        private Gtk.CenterBox middle_row;
        private Gtk.Grid bottom_row;
        private Gtk.CenterBox bottom_row_box;
        private Gtk.Revealer bottom_row_revealer;

        construct {
            build_ui ();
        }

        public DesktopLayout () {
            Object (
                width_request: 812,
                height_request: 600,
                hexpand: true,
                vexpand: true
            );

            build_ui ();
        }

        private void build_ui () {
            top_row = new Gtk.CenterBox () {
                hexpand = true,
                vexpand = true
            };
            attach (top_row, 0, 0);

            middle_row = new Gtk.CenterBox () {
                hexpand = true,
                vexpand = true
            };
            attach (middle_row, 0, 1);


            bottom_row_revealer = new Gtk.Revealer () {
                reveal_child = true,
                hexpand = true
            };
            attach (bottom_row_revealer, 0, 2);

            bottom_row = new Gtk.Grid () {
                hexpand = true
            };
            bottom_row_revealer.set_child (bottom_row);

            bottom_row_box = new Gtk.CenterBox ();
            bottom_row.attach (bottom_row_box, 0, 0);

            var start_button_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);
            start_button_box.add_css_class ("panel");
            bottom_row_box.set_center_widget (start_button_box);

            start_button = new Gtk.Button.from_icon_name ("media-playback-start-symbolic") {
                width_request = 64,
                height_request = 32
            };
            start_button.add_css_class (Granite.STYLE_CLASS_DESTRUCTIVE_ACTION);
            start_button.remove_css_class ("image-button");
            start_button.clicked.connect (() => {
                aw_core.get_style_engine ().toggle_play ();
            });

            start_button_box.append (start_button);
            start_button_box.append (new Gtk.Label (_("START/STOP")) { opacity = 0.5 });
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

            top_row.set_start_widget (assignables_board);
            top_row.set_center_widget (info_display);
            info_display.fill_screen = false;
            top_row.set_end_widget (synth_control_panel);

            middle_row.set_start_widget (voice_nav_panel);
            middle_row.set_center_widget (mixer_board);
            middle_row.set_end_widget (sampler_pads_panel);

            bottom_row_box.set_start_widget (style_control_panel);
            bottom_row_box.set_end_widget (registry_panel);
            bottom_row.attach (keyboard, 0, 1);
        }
    }
}
