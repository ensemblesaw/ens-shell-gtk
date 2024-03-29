/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

using Ensembles.ArrangerWorkstation;
using Ensembles.GtkShell.Widgets;

namespace Ensembles.GtkShell.Layouts {
    public class KeyboardPanel : Gtk.Grid, ControlSurface {
        public unowned ArrangerWorkstation.IAWCore aw_core { private get; construct; }
        public unowned Settings settings { private get; construct; }

        private Gtk.Overlay keyboard_info_bar;
        private Keyboard keyboard;

        construct {
            add_css_class ("keyboard");
            build_ui ();
            build_events ();
        }

        private void build_ui () {
            hexpand = true;
            vexpand = true;
            height_request = 128;

            keyboard_info_bar = new Gtk.Overlay () {
                hexpand = true,
                height_request = 32
            };
            keyboard_info_bar.add_css_class ("keyboard-info-bar");
            attach (keyboard_info_bar, 0, 0);

            var keyboard_button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 8) {
                halign = Gtk.Align.END
            };
            keyboard_info_bar.set_child (keyboard_button_box);

            var zoom_in_button = new Gtk.Button.from_icon_name ("zoom-in-symbolic");
            zoom_in_button.clicked.connect (() => {
                keyboard.zoom_level += 48;
            });
            keyboard_button_box.append (zoom_in_button);

            var zoom_out_button = new Gtk.Button.from_icon_name ("zoom-out-symbolic");
            zoom_out_button.clicked.connect (() => {
                keyboard.zoom_level -= 48;
            });
            keyboard_button_box.append (zoom_out_button);

            var zoom_reset_button = new Gtk.Button.from_icon_name ("zoom-fit-best-symbolic");
            zoom_reset_button.clicked.connect (() => {
                keyboard.zoom_level = 0;
            });
            keyboard_button_box.append (zoom_reset_button);

            var keyboard_scrollable = new Gtk.ScrolledWindow () {
                hexpand = true,
                vexpand = true,
                kinetic_scrolling = false,
                has_frame = false,

            };

            keyboard_scrollable.set_placement (Gtk.CornerType.BOTTOM_LEFT);
            attach (keyboard_scrollable, 0, 1);

            keyboard = new Keyboard (5) {
                octave_offset = 3
            };
            keyboard_scrollable.set_child (keyboard);
        }

        private void build_events () {
            keyboard.key_event.connect ((event) => {
                aw_core.send_midi (event);
            });
            aw_core.on_midi_receive.connect ((event) => {
                if (event.key >= 36 && event.key < 108) {
                    if (event.event_type == Models.MIDIEvent.EventType.NOTE_ON) {
                        keyboard.set_key_illumination (event.key, true);
                    } else if (event.event_type == Models.MIDIEvent.EventType.NOTE_OFF) {
                        keyboard.set_key_illumination (event.key, false);
                    }
                }

                return true;
            });
        }
    }
}
