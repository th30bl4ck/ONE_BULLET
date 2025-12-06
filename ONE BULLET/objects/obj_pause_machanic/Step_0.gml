if (keyboard_check_released(vk_escape)) {
    game_pause = !game_pause; // toggle pause

    if (game_pause) {
        instance_deactivate_all(true); // deactivate everything except persistent objects
    } else {
        instance_activate_all();
    }
}
