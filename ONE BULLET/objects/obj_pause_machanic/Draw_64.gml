if (game_pause) {
    var text = "Game Paused";
    var text_x = display_get_gui_width() / 2;
    var text_y = display_get_gui_height() / 2;

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(text_x, text_y, text);
}
