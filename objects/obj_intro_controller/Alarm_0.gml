if (phase == 0) {
    phase = 1;
    sprite_index = animation;
    image_index  = 0;
    image_speed  = 0.30;
} else {
    room_goto(main_menu);
}