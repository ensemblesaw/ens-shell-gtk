/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

using Ensembles.GtkShell.Widgets.Display;

namespace Ensembles.GtkShell.Layouts.Display {
    public class ModulatorScreen : DisplayWindow {
        public ModulatorScreen () {
            Object (
                subtitle: "Modulators",
                width_request: 200,
                height_request: 200,
                margin_top: 56,
                margin_bottom: 48,
                margin_start: 8,
                margin_end: 8,
                can_target: false
            );
        }

        construct {
            build_ui ();
            build_events ();
        }

        private void build_ui () {
            add_css_class ("modulator-screen");
            remove_css_class ("display-window-background");

        }

        private void build_events () {
            close.connect (pop_down);
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
