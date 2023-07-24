/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
using Ensembles.ArrangerWorkstation;
using Ensembles.ArrangerWorkstation.Plugins.AudioPlugins;

namespace Ensembles.GtkShell.Widgets.Display {
    public class DSPMenuItem : Gtk.ListBoxRow {
        public unowned AudioPlugin plugin { get; set; }

        private Gtk.Button insert_button;

        public signal void on_activate (AudioPlugin plugin);

        public DSPMenuItem (AudioPlugin plugin) {
            Object (
                plugin: plugin,
                height_request: 68
            );

            build_ui ();

            insert_button.clicked.connect (() => {
                on_activate (plugin);
            });
        }

        private void build_ui () {
            add_css_class ("plugin-item");

            var menu_item_grid = new Gtk.Grid ();
            set_child (menu_item_grid);

            var plugin_name_label = new Gtk.Label (plugin.name) {
                halign = Gtk.Align.START,
                hexpand = true
            };
            plugin_name_label.add_css_class ("plugin-item-name");
            menu_item_grid.attach (plugin_name_label, 0, 0);

            var extra_info_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 4);
            extra_info_box.add_css_class ("plugin-item-info");
            menu_item_grid.attach (extra_info_box, 0, 1);

            var extra_info_labels = new string[0];
            if (plugin.author_name != null && plugin.author_name.length > 0) {
                extra_info_labels.resize (1);
                if (plugin.author_name.length > 32) {
                    extra_info_labels[0] = plugin.author_name.substring (0, 32) + "…";
                } else {
                    extra_info_labels[0] = plugin.author_name;
                }
            }

            if (plugin.author_homepage != null && plugin.author_homepage.length > 0) {
                extra_info_labels.resize (extra_info_labels.length + 1);

                if (plugin.author_homepage.length > 36) {
                    extra_info_labels[extra_info_labels.length - 1] =
                    plugin.author_homepage.substring (0, 36) + "…";
                } else {
                    extra_info_labels[extra_info_labels.length - 1] = plugin.author_homepage;
                }

            }

            if (extra_info_labels.length > 0) {
                extra_info_box.append (
                    new Gtk.Label (string.joinv (" ⏺ ", extra_info_labels)) {
                        opacity = 0.5
                    }
                );
            }

            var plugin_protocol_name = "";
            switch (plugin.protocol) {
                case AudioPlugin.Protocol.LV2:
                plugin_protocol_name = "lv2";
                break;
                case AudioPlugin.Protocol.CARLA:
                plugin_protocol_name = "carla";
                break;
                case AudioPlugin.Protocol.LADSPA:
                plugin_protocol_name = "ladspa";
                break;
                case AudioPlugin.Protocol.NATIVE:
                plugin_protocol_name = "native";
                break;
            }

            if (plugin_protocol_name.length > 0) {
                var icon = new Gtk.Image.from_icon_name (
                    "plugin-audio-" +
                    plugin_protocol_name +
                    "-symbolic"
                );
                icon.add_css_class ("plugin-item-protocol");
                extra_info_box.append (icon);
            }

            insert_button = new Gtk.Button.from_icon_name ("insert-object-symbolic") {
                valign = Gtk.Align.START
            };
            insert_button.add_css_class ("plugin-item-insert-button");
            menu_item_grid.attach (insert_button, 1, 0, 1, 2);
        }
    }
}
