public interface MIDIControllable: Gtk.Widget {
    public abstract string uri { get; construct; }
    public abstract uint16 route_id { get; set; }
}
