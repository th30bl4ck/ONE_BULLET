if (!instance_exists(obj_player)) { 
    show_hint = false;
    exit;
}

show_hint = point_distance(x, y, obj_player.x, obj_player.y) < 24;

if (show_hint && keyboard_check_pressed(ord("E"))) {
    if (scr_shop(item_cost)) {
        audio_play_sound(snd_buy, 1, false);

        global.liquid_lead = true;
        instance_destroy();
    }
}

if (!instance_exists(obj_player)) { 
    show_hint = false;
    exit;
}

show_hint = point_distance(x, y, obj_player.x, obj_player.y) < 24;

if (show_hint && keyboard_check_pressed(ord("E"))) {
    if (scr_shop(item_cost)) {
        audio_play_sound(snd_buy, 1, false);

        global.liquid_lead = true;

        show_debug_message("LIQUID LEAD BOUGHT");

        instance_destroy();
    }
}