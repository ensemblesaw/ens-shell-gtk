/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

 namespace Ensembles.GtkShell.Layouts {
    public class KioskLayout : Gtk.Grid, ControlSurface {
        public unowned ArrangerWorkstation.IAWCore aw_core { private get; construct; }
        public unowned Settings settings { private get; construct; }

        public unowned InfoDisplay info_display { private get; construct; }
        public unowned MixerBoard mixer_board { private get; construct; }

        construct {
            add_css_class ("panel");
            build_ui ();
        }

        private void build_ui () {
            hexpand = true;
            vexpand = true;

            attach (info_display, 0, 0);
            attach (mixer_board, 0, 1);
        }
    }
}
