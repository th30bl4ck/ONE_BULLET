if (global.note_open) {
    var w = 420;
    var h = 200;
    var cx = display_get_gui_width() / 2;
    var cy = display_get_gui_height() / 2;

    draw_set_alpha(0.85);
    draw_rectangle(cx - w/2, cy - h/2, cx + w/2, cy + h/2, false);
    draw_set_alpha(1);

    draw_text(cx - w/2 + 16, cy - h/2 + 16, global.note_text);
    draw_text(cx + w/2 - 80, cy + h/2 - 24, "E to close");
}

if (global.note_open && keyboard_check_pressed(ord("E"))) {
    global.note_open = false;
}
