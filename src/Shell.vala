using Ensembles.Services;

namespace Ensembles.GtkShell {
    public class Shell : Gtk.Application {
        private static Shell _instance = null;

        public static Shell instance {
            get {
                if (_instance == null) {
                    try {
                        _instance = new Shell ();
                    } catch (Vinject.VinjectErrors e) {
                        handle_di_error (e);
                    }
                }

                return _instance;
            }
        }

        // Command Line Parameters
        private string[]? cl_arg_file = null;
        private bool cl_raw_midi_input = false;
        private bool cl_kiosk_mode = false;
        private bool cl_verbose = false;

        construct {
            flags |= ApplicationFlags.HANDLES_OPEN |
            ApplicationFlags.HANDLES_COMMAND_LINE;
        }

        private Shell () throws Vinject.VinjectErrors {
            Object (
                application_id: di_container.obtain (st_app_id)
            );
        }

        protected override void activate () {
            Console.log ("Initializing Main Window");

            try {
                di_container.register_singleton<MainWindow, Gtk.ApplicationWindow> (
                    st_main_window,
                    aw_core: st_aw_core,
                    settings: st_settings
                );

                Console.log (
                    "GUI Initialization Complete!",
                    Console.LogLevel.SUCCESS
                );

                di_container.obtain (st_aw_core).load_data_async ();

                var _settings = di_container.obtain (st_settings);
                var _version = di_container.obtain (st_version);

                if (_settings.version != _version) {
                    _settings.version = _version;

                    // Show welcome screen
                }
            } catch (Vinject.VinjectErrors e) {
                handle_di_error (e);
            }
        }
    }
}
