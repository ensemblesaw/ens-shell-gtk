using Ensembles.ArrangerWorkstation;

namespace Ensembles.GtkShell {
    /**
     * Interface for all UI widgets that interact with core services
     */
    public interface ControlSurface : Object {
        public abstract unowned IAWCore aw_core { protected get; construct; }
        public abstract unowned Settings settings { protected get; construct; }
    }
}
