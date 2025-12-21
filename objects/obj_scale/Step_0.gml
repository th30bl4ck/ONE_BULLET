// Adjust the view and GUI to scale cleanly with the window size
if (!view_enabled) exit;

var cam = view_camera[0];
if (cam == -1) exit;

// Capture the base resolution from the camera on first run
if (!base_set) {
    base_w = camera_get_view_width(cam);
    base_h = camera_get_view_height(cam);
    base_set = true;
    display_set_gui_size(base_w, base_h);
}

var win_w = window_get_width();
var win_h = window_get_height();

// Calculate the best scale: integer upscaling when possible, smooth downscaling when needed
var raw_scale = min(win_w / base_w, win_h / base_h);
var scale = raw_scale >= 1 ? floor(raw_scale) : raw_scale;

// Prevent degenerate scaling
if (scale <= 0) {
    scale = 1;
}

var port_w = round(base_w * scale);
var port_h = round(base_h * scale);
var port_x = (win_w - port_w) div 2;
var port_y = (win_h - port_h) div 2;

// Apply the calculated viewport to keep pixels crisp and centered
view_wport[0] = port_w;
view_hport[0] = port_h;
view_xport[0] = port_x;
view_yport[0] = port_y;

// Ensure the camera renders at the base resolution and the GUI matches it
camera_set_view_size(cam, base_w, base_h);
display_set_gui_size(base_w, base_h);
