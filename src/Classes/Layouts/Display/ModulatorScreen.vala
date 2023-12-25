/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

using Ensembles.GtkShell.Widgets.Display;

namespace Ensembles.GtkShell.Layouts.Display {
    public class ModulatorScreen : DisplayWindow {
        private GraphicalModulator gfx_modulator;

        private ModulatorScale pan_scale;
        private ModulatorScale reverb_scale;
        private ModulatorScale chorus_scale;
        private ModulatorScale pitch_scale;
        private ModulatorScale expression_scale;
        private ModulatorScale modulation_scale;
        private ModulatorScale brightness_scale;
        private ModulatorScale resonance_scale;

        public ModulatorScreen () {
            Object (
                subtitle: "Modulators",
                width_request: 200,
                height_request: 200,
                can_target: false
            );
        }

        construct {
            build_ui ();
            build_events ();
        }

        private void build_ui () {
            add_css_class ("modulator-screen");

            var grid = new Gtk.Grid () {
                column_spacing = 18,
                row_spacing = 18,
                row_homogeneous = true,
                column_homogeneous = true,
                hexpand = true,
                vexpand = true,
                margin_start = 18,
                margin_end = 18,
                margin_bottom = 18
            };
            set_child (grid);

            gfx_modulator = new GraphicalModulator ();
            grid.attach (gfx_modulator, 0, 0, 1, 4);

            pan_scale = new ModulatorScale.with_label ("Pan") {
                draw_fill = false
            };
            grid.attach (pan_scale, 1, 0);

            reverb_scale = new ModulatorScale.with_label ("Reverb");
            grid.attach (reverb_scale, 1, 1);

            chorus_scale = new ModulatorScale.with_label ("Chorus");
            grid.attach (chorus_scale, 1, 2);

            pitch_scale = new ModulatorScale.with_label ("Pitch") {
                draw_fill = false
            };
            grid.attach (pitch_scale, 1, 3);

            expression_scale = new ModulatorScale.with_label ("Expression");
            grid.attach (expression_scale, 2, 0);

            modulation_scale = new ModulatorScale.with_label ("Modulation");
            grid.attach (modulation_scale, 2, 1);

            brightness_scale = new ModulatorScale.with_label ("Brightness");
            grid.attach (brightness_scale, 2, 2);

            resonance_scale = new ModulatorScale.with_label ("Resonance");
            grid.attach (resonance_scale, 2, 3);
        }

        private void build_events () {
            close.connect (pop_down);

            pan_scale.value_changed.connect ((pan) => {
                gfx_modulator.pan = (uint8) pan;
            });
            pan_scale.value = 63;

            reverb_scale.value_changed.connect ((reverb) => {
                gfx_modulator.reverb = (uint8) reverb;
            });

            chorus_scale.value_changed.connect ((chorus) => {
                gfx_modulator.chorus = (uint8) chorus;
            });

            brightness_scale.value_changed.connect ((brightness) => {
                gfx_modulator.brightness = (uint8) brightness;
            });

            pitch_scale.value = 63;
        }

        public void pop_up (uint channel) {
            add_css_class ("popup");
            can_target = true;
            switch (channel) {
                case 17:
                    title = "Voice Channel Right 1";
                    break;
                case 18:
                    title = "Voice Channel Left (Split)";
                    break;
                case 19:
                    title = "Voice Channel Right 2 (Layer)";
                    break;
                default:
                    title = "Style Channel %u".printf (channel + 1);
                    break;
            }
        }

        public void pop_down () {
            remove_css_class ("popup");
            can_target = false;
        }
    }
}
