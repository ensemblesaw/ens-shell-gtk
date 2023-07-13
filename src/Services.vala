using Vinject;
using Ensembles.GtkShell;

namespace Ensembles.Services {
    extern static Injector di_container;

    public ServiceToken<string> st_app_id;
    public ServiceToken<string> st_version;
    public ServiceToken<Settings> st_settings;

    // UI tokens
    public ServiceToken<MainWindow> st_main_window;

    // Layout tokens
    public ServiceToken<Layouts.DesktopLayout> st_desktop_layout;
    public ServiceToken<Layouts.MobileLayout> st_mobile_layout;
    public ServiceToken<Layouts.KioskLayout> st_kiosk_layout;

    // Sub layouts
    public ServiceToken<Layouts.AssignablesBoard> st_assignables_board;
    public ServiceToken<Layouts.InfoDisplay> st_info_display;
    public ServiceToken<Layouts.SynthControlPanel> st_synth_control_panel;
    public ServiceToken<Layouts.VoiceNavPanel> st_voice_nav_panel;
    public ServiceToken<Layouts.MixerBoard> st_mixer_board;
    public ServiceToken<Layouts.SamplerPadsPanel> st_sampler_pads_panel;
    public ServiceToken<Layouts.StyleControlPanel> st_style_control_panel;
    public ServiceToken<Layouts.RegistryPanel> st_registry_panel;
    public ServiceToken<Layouts.KeyboardPanel> st_keyboard_panel;
    public ServiceToken<Layouts.BeatVisualization> st_beat_visualization;

    public void configure_settings_service (string app_id, string version) throws VinjectErrors {
        Services.st_app_id = new ServiceToken<string> ();
        Services.st_version = new ServiceToken<string> ();
        st_settings = new ServiceToken<Settings> ();

        st_main_window = new ServiceToken<MainWindow> ();

        st_desktop_layout = new ServiceToken<Layouts.DesktopLayout> ();
        st_mobile_layout = new ServiceToken<Layouts.MobileLayout> ();
        st_kiosk_layout = new ServiceToken<Layouts.KioskLayout> ();

        st_assignables_board = new ServiceToken<Layouts.AssignablesBoard> ();
        st_info_display = new ServiceToken<Layouts.InfoDisplay> ();
        st_synth_control_panel = new ServiceToken<Layouts.SynthControlPanel> ();
        st_voice_nav_panel = new ServiceToken<Layouts.VoiceNavPanel> ();
        st_mixer_board = new ServiceToken<Layouts.MixerBoard> ();
        st_sampler_pads_panel = new ServiceToken<Layouts.SamplerPadsPanel> ();
        st_style_control_panel = new ServiceToken<Layouts.StyleControlPanel> ();
        st_registry_panel = new ServiceToken<Layouts.RegistryPanel> ();
        st_keyboard_panel = new ServiceToken<Layouts.KeyboardPanel> ();
        st_beat_visualization = new ServiceToken<Layouts.BeatVisualization> ();

        di_container.register_constant (Services.st_app_id, app_id);
        di_container.register_constant (Services.st_version, version);
        di_container.register_transient<Ensembles.Settings, Settings> (
            st_settings, schema_id: app_id
        );
    }

    public string get_app_id () {
        try {
            return di_container.obtain (st_app_id);
        } catch (Vinject.VinjectErrors e) {
            Console.log ("FATAL: Dependency injection failed!", Console.LogLevel.ERROR);
        }
    }

    public void handle_di_error (VinjectErrors e) {
        Console.log ("FATAL: Dependency injection failed! " + e.message, Console.LogLevel.ERROR);
    }
}
