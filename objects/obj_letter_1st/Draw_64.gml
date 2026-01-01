if (global.note_open) {
    var w = 500;
    var h = 600;
    var cx = display_get_gui_width() / 2;
    var cy = display_get_gui_height() / 2;

    // popup background (light)
    draw_set_color(c_white);
    draw_rectangle(cx - w/2, cy - h/2, cx + w/2, cy + h/2, false);

    // text colour
    draw_set_color(c_black);
    draw_text(cx - w/2 + 16, cy - h/2 + 16, global.note_text);

    // hint text
    draw_text(cx + w/2 - 100, cy + h/2 - 30, "Q to close");

    // reset colour so it doesn't affect other UI
    draw_set_color(c_white);
}
