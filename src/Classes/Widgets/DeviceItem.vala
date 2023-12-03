/*
 * Copyright 2020-2022 Subhadeep Jasu <subhajasu@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

 namespace Ensembles.GtkShell {
    public class DeviceItem : Gtk.ListBoxRow {
        public unowned Models.MIDIDevice device;
        Gtk.Label device_name;
        public Gtk.CheckButton radio;
        public DeviceItem (Models.MIDIDevice device) {
            this.device = device;
            device_name = new Gtk.Label (this.device.name);
            radio = new Gtk.CheckButton () {
                margin_end = 8,
                active = false,
                sensitive = false
            };

            var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                margin_start = 8,
                margin_end = 8,
                margin_top = 8,
                margin_bottom = 8,
                halign = Gtk.Align.START
            };

            box.append (radio);
            box.append (device_name);
            set_child (box);
        }
    }
}
