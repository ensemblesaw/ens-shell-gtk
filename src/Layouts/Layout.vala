using Ensembles.ArrangerWorkstation;

namespace Ensembles.GtkShell.Layouts {
    public interface Layout : Gtk.Widget {
        public abstract unowned IAWCore aw_core { protected get; construct; }
        public abstract unowned Settings settings { protected get; construct; }
    }
}
