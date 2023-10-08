/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

using Ensembles.ArrangerWorkstation;
namespace Ensembles.GtkShell.Widgets.Display {
    public class ModulatorScale : Gtk.Box, Gtk.Accessible {
        public string label { get; set construct; }
        public bool draw_value { get; set; }
        public bool draw_fill { get; set; }

        /**
         * The adjustment that is controlled by the scale.
         */
        public Gtk.Adjustment adjustment { get; set; }
        /**
         * Current value of the knob.
        */
        public double value {
            get {
                return adjustment.value;
            }
            set {
                adjustment.value = value;
                drawing_area.queue_draw ();
            }
        }

        private double previous_value;


        private Gtk.Overlay overlay;
        private Gtk.Grid overlay_grid;
        private Gtk.DrawingArea drawing_area;

        private Gtk.GestureDrag drag_gesture;
        //  private Gtk.EventControllerScroll wheel_gesture;

        public signal void value_changed (double value);

        public ModulatorScale () {
            Object (
                name: "slider",
                accessible_role: Gtk.AccessibleRole.SLIDER,
                hexpand: true,
                vexpand: true
            );
        }

        public ModulatorScale.with_label (string text) {
            Object (
                name: "slider",
                accessible_role: Gtk.AccessibleRole.SLIDER,
                hexpand: true,
                vexpand: true,
                label: text
            );
        }

        construct {
            draw_value = true;
            draw_fill = true;
            adjustment = new Gtk.Adjustment (0, 0, 127,
                1, 0, 0);
            build_ui ();
            build_event ();
        }

        private void build_ui () {
            add_css_class ("modulator-scale");

            overlay = new Gtk.Overlay () {
                hexpand = true,
                vexpand = true
            };
            append (overlay);

            drawing_area = new Gtk.DrawingArea ();
            drawing_area.set_draw_func (draw);
            overlay.set_child (drawing_area);

            overlay_grid = new Gtk.Grid ();
            overlay.add_overlay (overlay_grid);

            var name_label = new Gtk.Label (label) {
                margin_start = 4,
                margin_top = 4
            };
            overlay_grid.attach (name_label, 0, 0, 1, 2);
        }

        protected void draw (Gtk.DrawingArea meter, Cairo.Context cr, int width, int height) {
            if (width > 0 && height > 0) {
                double degrees = Math.PI / 180.0;
                double radius = 3.0;
                cr.new_sub_path ();
                cr.arc (width - radius, radius, radius, -90 * degrees, 0);
                cr.arc (width - radius, height - radius, radius, 0, 90 * degrees);
                cr.arc (radius, height - radius, radius, 90 * degrees, 180 * degrees);
                cr.arc (radius, radius, radius, 180 * degrees, 270 * degrees);
                cr.close_path ();

                cr.clip ();
            }

            var _x = Utils.Math.map_range_unclamped (adjustment.value, 0, 128, 0, width);

            if (draw_fill) {
                cr.rectangle (0, 0, _x, height);
                cr.set_source_rgba (0.24, 0.66, 0.49, 0.3);
                cr.fill ();
            }

            cr.new_path ();
            cr.move_to (_x, 0);
            cr.line_to (_x, height);
            cr.set_source_rgb (0.24, 0.66, 0.49);
            cr.close_path ();
            cr.stroke ();

            if (draw_value) {
                string text = (adjustment.step_increment >= 1 ? "%.lf" : "%.1lf").printf (adjustment.value);
                cr.select_font_face ("Michroma", Cairo.FontSlant.NORMAL, Cairo.FontWeight.NORMAL);
                cr.set_font_size (12);

                Cairo.TextExtents extents;
                cr.text_extents (text, out extents);

                cr.move_to (width - extents.width - 4, extents.height + 4);
                cr.set_source_rgba (1, 1, 1, 0.5);
                cr.show_text (text);
            }
        }

        private void build_event () {
            drag_gesture = new Gtk.GestureDrag () {
                propagation_phase = Gtk.PropagationPhase.CAPTURE,
                name = "drag-capture"
            };
            add_controller (drag_gesture);

            drag_gesture.drag_begin.connect ((x, y) => {
                previous_value = adjustment.value;
            });

            drag_gesture.drag_update.connect ((x, y) => {
                var _d = Utils.Math.map_range_unclamped (
                    x,
                    0,
                    get_width (),
                    adjustment.lower,
                    adjustment.upper
                );

                adjustment.set_value (previous_value + _d);

                drawing_area.queue_draw ();
            });

            adjustment.value_changed.connect ((_adj) => {
                value_changed (_adj.value);
            });
        }

        private float[] get_eq_color () {
            switch (Theme.theme_color) {
                case "strawberry":
                    return { 0.92f, 0.32f, 0.32f };
                case "orange":
                    return { 1, 0.63f, 0.32f };
                case "banana":
                    return { 1, 0.88f, 0.42f };
                case "lime":
                    return { 0.6f, 0.85f, 0.3f };
                case "mint":
                    return { 0.26f, 0.84f, 0.71f };
                case "blueberry":
                    return { 0.39f, 0.73f, 1 };
                case "grape":
                    return { 0.8f, 0.62f, 0.96f };
                case "bubblegum":
                    return { 0.95f, 0.4f, 0.61f };
                case "cocoa":
                    return { 0.54f, 0.44f, 0.36f };
                default:
                    return { 0.9f, 0.9f, 0.9f };
            }
        }
    }
}
