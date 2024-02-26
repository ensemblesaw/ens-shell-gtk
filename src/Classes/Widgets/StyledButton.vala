/*
 * Copyright 2020-2024 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Ensembles.GtkShell.Widgets {
    public class StyledButton: Gtk.Button, ContextMenuTrigger {
        public Gtk.GestureClick click_gesture { get; private set; }
        public Gtk.GestureLongPress long_press_gesture { get; private set; }

        public StyledButton () {
            Object ();
        }

        public StyledButton.with_label (string? text) {
            Object (
                label: text
            );
        }

        public StyledButton.from_icon_name (string? icon_name) {
            Object (
                icon_name: icon_name
            );
        }

        construct {
            build_events ();
        }

        private void build_events () {
            click_gesture = new Gtk.GestureClick () {
                button = 3
            };
            add_controller (click_gesture);

            long_press_gesture = new Gtk.GestureLongPress ();
            add_controller (long_press_gesture);

            click_gesture.pressed.connect (() => {
                menu_activated ();
            });

            long_press_gesture.pressed.connect (() => {
                menu_activated ();
            });
        }
    }
}
