/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Ensembles.GtkShell.Layouts {
    public class BeatVisualization : Gtk.Box, ControlSurface {
        public unowned ArrangerWorkstation.IAWCore aw_core { private get; construct; }
        public unowned Settings settings { private get; construct; }

        Gtk.Fixed beat_counter_visual;
        private uint beat_count = 0;
        private uint8 tempo = 120;
        private uint8 beats_per_bar = 4;
        private uint8 beat_duration = 4;

        private Gtk.Button tempo_button;

        public signal void start_tempo_change ();

        construct {
            build_ui ();
            build_events ();
        }

        private void build_ui () {
            beat_counter_visual = new Gtk.Fixed () {
                width_request = 108,
                height_request = 32,
                valign = Gtk.Align.CENTER
            };

            beat_counter_visual.add_css_class ("beat-counter-0");
            append (beat_counter_visual);

            tempo_button = new Gtk.Button.with_label (_("Tempo"));
            append (tempo_button);
        }

        private void build_events () {
            aw_core.beat.connect (beat);
            aw_core.beat_reset.connect (reset);

            tempo_button.clicked.connect (() => {
                start_tempo_change ();
            });
        }

        public void beat (bool is_measure, uint measure, uint8 beats_per_bar, uint8 beat_duration) {
            this.beats_per_bar = beats_per_bar;
            this.beat_duration = beat_duration;

            if (is_measure) {
                beat_count = 1;
            }

            if (beat_count < 5) {
                set_beat_graphic (beat_count);
                Timeout.add (120000 / (tempo * beat_duration), () => {
                    set_beat_graphic (0);
                    return false;
                });
            } else {
                beat_count = 1;
            }

            beat_count++;
        }

        public void reset () {
            beat_count = 0;
        }

        private void set_beat_graphic (uint val) {
            Idle.add (() => {
                switch (val) {
                    case 0:
                    beat_counter_visual.add_css_class ("beat-counter-0");
                    beat_counter_visual.remove_css_class ("beat-counter-1");
                    beat_counter_visual.remove_css_class ("beat-counter-2");
                    beat_counter_visual.remove_css_class ("beat-counter-3");
                    beat_counter_visual.remove_css_class ("beat-counter-4");
                    break;
                    case 1:
                    beat_counter_visual.remove_css_class ("beat-counter-0");
                    beat_counter_visual.add_css_class ("beat-counter-1");
                    beat_counter_visual.remove_css_class ("beat-counter-2");
                    beat_counter_visual.remove_css_class ("beat-counter-3");
                    beat_counter_visual.remove_css_class ("beat-counter-4");
                    break;
                    case 2:
                    beat_counter_visual.remove_css_class ("beat-counter-0");
                    beat_counter_visual.remove_css_class ("beat-counter-1");
                    beat_counter_visual.add_css_class ("beat-counter-2");
                    beat_counter_visual.remove_css_class ("beat-counter-3");
                    beat_counter_visual.remove_css_class ("beat-counter-4");
                    break;
                    case 3:
                    beat_counter_visual.remove_css_class ("beat-counter-0");
                    beat_counter_visual.remove_css_class ("beat-counter-1");
                    beat_counter_visual.remove_css_class ("beat-counter-2");
                    beat_counter_visual.add_css_class ("beat-counter-3");
                    beat_counter_visual.remove_css_class ("beat-counter-4");
                    break;
                    case 4:
                    beat_counter_visual.remove_css_class ("beat-counter-0");
                    beat_counter_visual.remove_css_class ("beat-counter-1");
                    beat_counter_visual.remove_css_class ("beat-counter-2");
                    beat_counter_visual.remove_css_class ("beat-counter-3");
                    beat_counter_visual.add_css_class ("beat-counter-4");
                    break;
                }

                return false;
            });
        }
    }
}
