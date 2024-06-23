using Ensembles.ArrangerWorkstation.Utils;

namespace Ensembles.GtkShell {
    public class UIMap : Object {
        private SyMap symap;
        private Mutex mutex;

        construct {
            symap = new SyMap ();
            mutex = Mutex ();
        }

        public uint16 map_uri (string uri) {
            mutex.lock ();
            uint16 id = (uint16) symap.map (uri);
            mutex.unlock ();
            return id;
        }

        public string unmap_uri (uint16 id) {
            mutex.lock ();
            string uri = symap.unmap (id);
            mutex.unlock ();
            return uri;
        }
    }
}
