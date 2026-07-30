draw_self();

if (point_distance(x, y, obj_player.x, obj_player.y) < 48)
{
    draw_set_font(dialouge_font);
    draw_set_halign(fa_center);
    draw_set_color(c_lime);

    draw_text(x, y - 50, "Press E to Talk");

    draw_set_halign(fa_left);
}