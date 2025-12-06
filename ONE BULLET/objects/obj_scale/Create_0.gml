// Handle clean integer-based scaling for all rooms
// Default to the base room resolution; update once a camera is available
base_w = 1366;
base_h = 768;
base_set = false;

// Keep the GUI at the base resolution so UI elements remain crisp
if (display_get_gui_width() != base_w || display_get_gui_height() != base_h) {
    display_set_gui_size(base_w, base_h);
}
