if (!instance_exists(obj_player)) {
    show_hint = false;
    exit;
}

show_hint = point_distance(x, y, obj_player.x, obj_player.y) < 24;

if (show_hint && keyboard_check_pressed(ord("E"))) {
    if (scr_shop(item_cost)) {
        instance_destroy();
    }
}
