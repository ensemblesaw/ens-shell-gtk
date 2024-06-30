/*
 * Copyright 2020-2022 Subhadeep Jasu <subhajasu@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Ensembles.GtkShell {
    public class Drumkit : Gtk.Widget, Gtk.Accessible {

        private bool update = true;
        private int width;
        private int height;

        private double highhat_aspect_ratio = 0.444444;
        private Gtk.Button highhat_button;

        public Drumkit () {
            Object (
                accessible_role: Gtk.AccessibleRole.TABLE,
                name: "drumkit",
                css_name: "drumkit",
                layout_manager: new Gtk.BoxLayout (Gtk.Orientation.HORIZONTAL),
                height_request: 100
            );
        }

        ~Drumkit () {
            update = false;
        }

        construct {
            build_ui ();
        }

        private void build_ui () {
            var fixed = new Gtk.Fixed ();
            fixed.set_parent (this);

            highhat_button = new Gtk.Button ();
            highhat_button.add_css_class ("drumkit-highhat");
            fixed.put (highhat_button, 8, 0);

            Timeout.add (80, () => {
                Idle.add (() => {
                    if (width != get_width () || height != get_height ()) {
                        // Update content here upon resize:
                        var __height = parent.get_height () - 1;

                        highhat_button.height_request = __height;
                        highhat_button.width_request = (int) (__height * highhat_aspect_ratio);

                        width = get_width ();
                        height = __height;
                    }

                    return false;
                }, Priority.LOW);
                return update;
            }, Priority.LOW);
        }

        public void animate (uint8 key_index, bool active) {
            print(key_index.to_string ());
            if (active) {
                switch (key_index) {
                    case 42:
                    case 44:
                        highhat_button.add_css_class ("closed");
                        break;
                    case 46:
                        highhat_button.add_css_class ("active");
                        break;
                }
            } else {
                switch (key_index) {
                    case 42:
                    case 44:
                        highhat_button.remove_css_class ("closed");
                        break;
                    case 46:
                        highhat_button.remove_css_class ("active");
                        break;
                }
            }
        }
    }
}
