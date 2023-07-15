/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Ensembles.GtkShell.Layouts {
    public class AssignablesBoard : Gtk.Grid, ControlSurface {
        public unowned ArrangerWorkstation.IAWCore aw_core { private get; construct; }
        public unowned Settings settings { private get; construct; }

        construct {
            add_css_class ("panel");
        }

        public AssignablesBoard () {
            Object (
                hexpand: true,
                vexpand: true
            );
        }
    }
}