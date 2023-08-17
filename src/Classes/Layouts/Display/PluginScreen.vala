/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

using Ensembles.GtkShell.Widgets.Display;
using Ensembles.ArrangerWorkstation.Plugins;
using Ensembles.ArrangerWorkstation.Plugins.AudioPlugins;

namespace Ensembles.GtkShell.Layouts.Display {
    /**
     * Shows the plugin UI.
     */
    public class PluginScreen : DisplayWindow {
        public unowned Plugin plugin { get; protected set construct; }
        public string? history { get; set; }

        private Gtk.Switch active_switch;
        private Widgets.Knob gain_knob;

        public PluginScreen (Plugin plugin) {
            var _subtitle_str = "";

            if (plugin is AudioPlugin) {
                var _audio_plugin = (AudioPlugin) plugin;
                switch (_audio_plugin.protocol) {
                    case AudioPlugin.Protocol.LV2:
                    _subtitle_str += _("LV2 Plugin");
                    break;
                    case AudioPlugin.Protocol.CARLA:
                    _subtitle_str += _("Carla Plugin");
                    break;
                    case AudioPlugin.Protocol.LADSPA:
                    _subtitle_str += _("LADSPA Plugin");
                    break;
                    case AudioPlugin.Protocol.NATIVE:
                    _subtitle_str += _("Ensembles Plugin");
                    break;
                }
            }

            Object (
                plugin: plugin,
                title: plugin.name,
                subtitle: _subtitle_str
            );
        }

        construct {
            build_ui ();
            build_events ();
        }

        private void build_ui () {
            if (plugin is AudioPlugin) {
                gain_knob = new Widgets.Knob.with_range (-12, 0, 1) {
                    width_request = 40,
                    height_request = 40,
                    halign = Gtk.Align.CENTER,
                    valign = Gtk.Align.CENTER,
                    tooltip_text = _("Dry / Wet Mix")
                };
                gain_knob.add_css_class ("small");

                gain_knob.value = ArrangerWorkstation.Utils.Math.convert_gain_to_db (((AudioPlugin) plugin).mix_gain);
                gain_knob.add_mark (-12);
                gain_knob.add_mark (0);
                add_to_header (gain_knob);
            }

            active_switch = new Gtk.Switch () {
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER,
                margin_end = 8
            };
            active_switch.active = plugin.active;
            add_to_header (active_switch);

            var scrollable = new Gtk.ScrolledWindow () {
                vexpand = true,
                hexpand = true
            };
            append (scrollable);

            if (plugin.has_ui) {
                scrollable.set_child (get_plugin_ui ());
            }
        }

        private void build_events () {
            active_switch.notify["active"].connect (() => {
                plugin.active = active_switch.active;
            });

            if (plugin is AudioPlugin) {
                gain_knob.value_changed.connect ((db) => {
                    ((AudioPlugin) plugin).mix_gain = (float) ArrangerWorkstation.Utils.Math.convert_db_to_gain (db);
                });
            }
        }

        private Gtk.Widget get_plugin_ui () {
            if (plugin is AudioPlugin) {
                switch (((AudioPlugin) plugin).protocol) {
                    case AudioPlugin.Protocol.LV2:
                    return get_lv2_plugin_ui ();
                    default:
                    return new Gtk.Label ("INVALID PLUGIN");
                }
            }

            return new Gtk.Label ("INVALID PLUGIN");
        }

        private Gtk.Widget get_lv2_plugin_ui () {
            var _lv2_plugin = (Lv2.LV2Plugin) plugin;
            var box = new Gtk.Box (
                Gtk.Orientation.HORIZONTAL,
                8
            ) {
                spacing = 4,
                valign = Gtk.Align.CENTER,
                homogeneous = _lv2_plugin.control_in_ports.length < 4
            };

            if (_lv2_plugin.control_in_ports.length > 0) {
                for (uint i = 0; i < _lv2_plugin.control_in_ports.length; i++) {
                    var plugin_control = new Plugins.AudioPlugins.Widgets.AudioPluginControl (
                        _lv2_plugin.control_in_ports[i],
                        _lv2_plugin.control_in_ports.length > 3 ? Gtk.IconSize.NORMAL : Gtk.IconSize.LARGE
                    );
                    box.append (plugin_control);
                }
            }

            return box;
        }
    }
}
