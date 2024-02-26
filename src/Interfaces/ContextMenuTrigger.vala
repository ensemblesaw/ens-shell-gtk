namespace Ensembles.GtkShell {
    /**
     * Widget that triggers context menu on right click
     * or long press or when context meny key is pressed.
     */
    public interface ContextMenuTrigger : Gtk.Widget {
        /**
         * Activated when right click or long press is done or when
         * context menu key is pressed.
         */
        public signal void menu_activated ();

        public abstract Gtk.GestureClick click_gesture { get; protected set; }
        public abstract Gtk.GestureLongPress long_press_gesture { get; protected set; }
    }
}
