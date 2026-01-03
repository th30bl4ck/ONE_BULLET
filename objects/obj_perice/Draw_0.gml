draw_self();

if (show_hint) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(x, y - 16, "E - " + string(item_cost) + " coins");
}
