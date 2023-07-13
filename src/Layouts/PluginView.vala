/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Ensembles.GtkShell.Layouts {
    public class PluginView : Gtk.Box, ControlSurface {
        public unowned ArrangerWorkstation.IAWCore aw_core { private get; construct; }
        public unowned Settings settings { private get; construct; }

        public weak Display.DisplayWindow plugin_ui { get; set; }

        public void reparent () {
            plugin_ui.unparent ();
            append (plugin_ui);
        }
    }
}
