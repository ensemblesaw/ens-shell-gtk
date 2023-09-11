/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

using Ensembles.Models;

namespace Ensembles.GtkShell.Widgets.Display {
    public class StyleMenuItem : Gtk.ListBoxRow {
        public Style style { get; construct; }
        public uint16 index { get; construct; }
        public bool show_category { get; construct; }

        public StyleMenuItem (uint16 index, Style style, bool show_category = false) {
            Object (
                index: index,
                style: style,
                show_category: show_category
            );

            build_ui ();
        }

        private void build_ui () {
            add_css_class ("menu-item");

            var menu_item_grid = new Gtk.Grid () {
                column_spacing = 16,
                row_spacing = 0
            };
            set_child (menu_item_grid);

            if (show_category) {
                var category_label = new Gtk.Label (style.genre) {
                    xalign = 0
                };
                category_label.add_css_class ("menu-item-category");

                menu_item_grid.attach (category_label, 0, 0, 3, 1);
            }

            var index_label = new Gtk.Label ("%03u".printf (index)) {
                width_chars = 3,
                xalign = 0
            };
            index_label.add_css_class ("menu-item-index");
            menu_item_grid.attach (index_label, 0, 1);

            var style_name_label = new Gtk.Label (style.name) {
                halign = Gtk.Align.START,
                hexpand = true,
                height_request = 48
            };
            style_name_label.add_css_class ("menu-item-name");
            menu_item_grid.attach (style_name_label, 1, 1);

            var tempo_label = new Gtk.Label (style.time_signature_n.to_string () +
            "/" +
            style.time_signature_d.to_string () +
            "\t" +
            (((double)style.tempo / 100.0 >= 1) ? "" : " ") +
            "♩ =  " + style.tempo.to_string ()) {
                halign = Gtk.Align.END
            };
            tempo_label.add_css_class ("menu-item-description");
            menu_item_grid.attach (tempo_label, 1, 1);

            if (style.copyright_notice != null && style.copyright_notice != "") {
                var copyright_button = new Gtk.Button.from_icon_name ("text-x-copying-symbolic") {
                    margin_top = 6,
                    margin_bottom = 6,
                    margin_start = 4,
                    margin_end = 4,
                    width_request = 32,
                    tooltip_text = _("Copyright Notices and Credits")
                };
                copyright_button.add_css_class ("menu-item-icon");
                menu_item_grid.attach (copyright_button, 2, 1);
            }
        }
    }
}
