namespace Ensembles.GtkShell {
    public class ShellBuilder : Object {
        internal string app_name = "Ensembles";
        internal string icon_name = "";
        internal string app_id = "";
        internal string version = "0";
        internal string display_version = "000";

        public delegate void ShellBuilderCallback (ShellBuilder shell_builder);

        public ShellBuilder with_app_id (string app_id) {
            this.app_id = app_id;
            return this;
        }

        public ShellBuilder with_name (string name) {
            app_name = name;
            return this;
        }

        public ShellBuilder with_icon_name (string icon_name) {
            this.icon_name = icon_name;
            return this;
        }

        public ShellBuilder has_version (string version, string display_version) {
            this.version = version;
            this.display_version = display_version;
            return this;
        }
    }
}
