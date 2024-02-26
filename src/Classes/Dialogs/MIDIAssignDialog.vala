/*
 * Copyright 2020-2024 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Ensembles.GtkShell.Dialog {
    public class MIDIAssignDialog : Granite.Dialog {
        public uint16 route { get; construct; }

        private Gtk.Revealer revealer;
        private Gtk.Label subheading;
        private Gtk.Button confirm_button;
        private Gtk.Button cancel_button;

        public signal void assigned (uint16 control_route);
        public signal void cancelled ();

        public MIDIAssignDialog (Gtk.Window? main_window, uint16 route) {
            Object (
                modal: true,
                transient_for: main_window,
                width_request: 500,
                route: route,
                title: _("Link MIDI Controller"),
                resizable: false,
                deletable: true
            );
        }

        construct {
            build_ui ();
            build_events ();
        }

        private void build_ui () {
            var main_grid = new Gtk.Box (Gtk.Orientation.VERTICAL, 4);
            set_child (main_grid);

            var controller_image = new Gtk.Image.from_resource (
                "/com/github/ensemblesaw/ens-shell-gtk/images/controller_assign") {
                halign = Gtk.Align.CENTER,
                margin_bottom = 26,
                margin_top = 26
            };
            controller_image.set_size_request (76, 77);
            controller_image.add_css_class (Granite.STYLE_CLASS_CARD);
            controller_image.add_css_class (Granite.STYLE_CLASS_ROUNDED);
            main_grid.append (controller_image);

            var header_label = new Gtk.Label (_("Link MIDI Controller")) {
                hexpand = true,
                height_request = 32
            };
            header_label.add_css_class (Granite.STYLE_CLASS_H2_LABEL);
            main_grid.append (header_label);

            subheading = new Gtk.Label (_("Waiting for you to move a knob, fader or key on your MIDI Controller…")) {
                margin_top = 8,
                margin_start = 12,
                margin_end = 12,
                margin_bottom = 0,
            };
            subheading.add_css_class (Granite.STYLE_CLASS_H4_LABEL);
            main_grid.append (subheading);

            revealer = new Gtk.Revealer () {
                transition_type = Gtk.RevealerTransitionType.SLIDE_DOWN
            };

            confirm_button = new Gtk.Button.with_label (_("Confirm")) {
                hexpand = true,
                margin_top = 12,
                margin_start = 12,
                margin_end = 12,
                margin_bottom = 0
            };
            confirm_button.add_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
            revealer.set_child (confirm_button);
            main_grid.append (revealer);

            cancel_button = new Gtk.Button.with_label (_("Cancel")) {
                hexpand = true,
                margin_top = 12,
                margin_start = 12,
                margin_end = 12,
                margin_bottom = 12
            };
            main_grid.append (cancel_button);
        }

        private void build_events () {
            cancel_button.clicked.connect (() => {
                cancelled ();
                close ();
            });

            confirm_button.clicked.connect (() => {
                assigned (route);
                close ();
            });
        }

        public void set_configuration_details (uint8 type, uint8 channel, uint8 data) {
            var _type = "";
            if (type == Models.MIDIEvent.EventType.NOTE_ON) {
                _type = "Note: %u".printf (data);
            } else if (type == Models.MIDIEvent.EventType.CONTROL_CHANGE) {
                switch (data) {
                    case Models.MIDIEvent.Control.GAIN:
                        _type = "Gain";
                        break;
                    case Models.MIDIEvent.Control.BRIGHTNESS:
                        _type = "Brightness";
                        break;
                    case Models.MIDIEvent.Control.RESONANCE:
                        _type = "Resonance";
                        break;
                    case Models.MIDIEvent.Control.REVERB:
                        _type = "Reverb";
                        break;
                    case Models.MIDIEvent.Control.CHORUS:
                        _type = "Chorus";
                        break;
                    case Models.MIDIEvent.Control.MODULATION:
                        _type = "Modulation";
                        break;
                    case Models.MIDIEvent.Control.PAN:
                        _type = "Stereo Pan";
                        break;
                    case Models.MIDIEvent.Control.PITCH:
                        _type = "Pitch Bend";
                        break;
                    case Models.MIDIEvent.Control.EXPRESSION:
                        _type = "Expression";
                        break;
                    default:
                        _type = "CC: %u".printf (data);
                        break;
                }
            }

            subheading.set_text (_("%s, Channel %u").printf (_type, channel + 1));
            revealer.reveal_child = true;
        }
    }
}
