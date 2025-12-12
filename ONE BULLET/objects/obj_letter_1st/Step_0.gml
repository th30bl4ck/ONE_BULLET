show_hint = point_distance(x, y, obj_player.x, obj_player.y) < 24;
draw_set_color(c_black);
if (show_hint) {
    global.active_note = id;
}

// INPUT (must be AFTER notes update)
if (!global.note_open && keyboard_check_pressed(ord("E"))) {
    if (instance_exists(global.active_note)) {
        global.note_open = true;
        global.note_text = global.active_note.note_text;
    }
}

if (global.note_open && keyboard_check_pressed(ord("Q"))) {
    global.note_open = false;
}

