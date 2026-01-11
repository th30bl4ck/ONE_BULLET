draw_self();

if (state == 1 && instance_exists(obj_player)) {
    var a = point_direction(x, y, obj_player.x, obj_player.y);
    var len = 18 + (windup_max - windup) * 0.4;

    draw_set_alpha(0.6);
    draw_line_width(x, y, x + lengthdir_x(len, a), y + lengthdir_y(len, a), 2);
    draw_set_alpha(1);
}
