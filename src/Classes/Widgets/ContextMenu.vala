namespace Ensembles.GtkShell {
    public class ContextMenu : Gtk.Popover, ControlSurface {
        public unowned ArrangerWorkstation.IAWCore aw_core { private get; construct; }
        public unowned Settings settings { private get; construct; }

        private Gtk.Label controller_assignment_label;
        private Gtk.Button controller_assign_button;
        private Gtk.Button controller_reset_button;
        private Gtk.Separator ctx_menu_main_separator;

        public string? control_uri { get; set; }

        public string assignment_label {
            get {
                return controller_assignment_label.get_text ();
            }
            set {
                controller_assignment_label.set_text (value);

                if (value.length > 0) {
                    controller_assignment_label.visible = true;
                    controller_reset_button.visible = true;
                    ctx_menu_main_separator.visible = true;
                } else {
                    controller_assignment_label.visible = false;
                    controller_reset_button.visible = false;
                    ctx_menu_main_separator.visible = false;
                }
            }
        }

        public signal void assign (string? uri);
        public signal void clear_assignment (string? uri);

        construct {
            build_ui ();
            build_events ();
        }

        private void build_ui () {
            var button_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 4) {
                margin_start = 4,
                margin_end = 4,
                margin_top = 4,
                margin_bottom = 4
            };

            controller_assignment_label = new Gtk.Label ("") {
                halign = Gtk.Align.START,
                visible = false
            };

            controller_assignment_label.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);
            button_box.append (controller_assignment_label);

            ctx_menu_main_separator = new Gtk.Separator (Gtk.Orientation.HORIZONTAL) {
                visible = false
            };

            button_box.append (ctx_menu_main_separator);

            controller_assign_button = new Gtk.Button ();
            var assign_button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 4) {
                halign = Gtk.Align.START
            };

            assign_button_box.append (new Gtk.Image.from_icon_name ("insert-link"));
            assign_button_box.append (new Gtk.Label (_("Link MIDI Controller")));
            controller_assign_button.set_child (assign_button_box);
            controller_assign_button.get_style_context ().add_class (Granite.STYLE_CLASS_FLAT);
            button_box.append (controller_assign_button);

            controller_reset_button = new Gtk.Button ();
            var reset_button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 4) {
                halign = Gtk.Align.START
            };

            reset_button_box.append (new Gtk.Image.from_icon_name ("list-remove"));
            reset_button_box.append (new Gtk.Label (_("Remove Link")));
            controller_reset_button.set_child (reset_button_box);
            controller_reset_button.get_style_context ().add_class (Granite.STYLE_CLASS_FLAT);
            button_box.append (controller_reset_button);

            set_child (button_box);
        }

        private void build_events () {
            controller_assign_button.clicked.connect (() => {
                assign (control_uri);
            });
        }
    }
}
