namespace Ensembles.GtkShell.Layouts.Display {
    public class TempoScreen : Gtk.Grid {
        private Gtk.Label tempo_label;
        private Gtk.Button decrease_tempo_button;
        private Gtk.Button increase_tempo_button;
        private Gtk.Button close_button;
        private Gtk.Button tap_button;
        private Gtk.Button reset_button;

        public signal void close ();

        public TempoScreen () {
            Object (
                width_request: 200,
                height_request: 200,
                margin_top: 140,
                margin_bottom: 8,
                margin_start: 8,
                margin_end: 8,
                can_target: false,
                halign: Gtk.Align.CENTER,
                valign: Gtk.Align.CENTER
            );
        }

        construct {
            build_ui ();
        }

        private void build_ui () {
            add_css_class ("tempo-screen");

            var upper_region = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 8);
            attach (upper_region, 0, 0);

            decrease_tempo_button = new Gtk.Button.with_label ("-");
            decrease_tempo_button.add_css_class ("tempo-screen-text-button-big");
            upper_region.append (decrease_tempo_button);

            tempo_label = new Gtk.Label ("120") {
                width_request = 256
            };
            tempo_label.add_css_class ("tempo-label");
            upper_region.append (tempo_label);

            increase_tempo_button = new Gtk.Button.with_label ("+");
            increase_tempo_button.add_css_class ("tempo-screen-text-button-big");
            upper_region.append (increase_tempo_button);

            var bpm_label = new Gtk.Label ("BPM");
            bpm_label.add_css_class ("tempo-bpm-label");
            attach (bpm_label, 0, 1);

            var lower_region = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12) {
                halign = Gtk.Align.CENTER,
                margin_top = 24
            };
            attach (lower_region, 0, 2);

            close_button = new Gtk.Button.from_icon_name ("window-close-symbolic");
            close_button.add_css_class ("outlined-button-alt");
            lower_region.append (close_button);

            tap_button = new Gtk.Button.with_label (_("Tap")) {
                width_request = 256
            };
            tap_button.add_css_class ("outlined-button-alt");
            lower_region.append (tap_button);

            reset_button = new Gtk.Button.from_icon_name ("edit-undo-symbolic");
            reset_button.add_css_class ("outlined-button-alt");
            lower_region.append (reset_button);
        }

        private void build_events () {
            close_button.clicked.connect (() => {
                close ();
            });
        }

        public void pop_up () {
            add_css_class ("popup");
            can_target = true;
        }

        public void pop_down () {
            remove_css_class ("popup");
            can_target = false;
        }
    }
}
