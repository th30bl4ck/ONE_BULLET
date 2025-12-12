show_hint = point_distance(x, y, obj_player.x, obj_player.y) < 24;

if (show_hint && keyboard_check_pressed(ord("E"))) {
    global.note_open = true;
    global.note_text = note_text;
}

if (keyboard_check_pressed(ord("E"))) {
    if (global.note_open) {
        global.note_open = false;
    } else if (instance_exists(global.active_note)) {
        global.note_open = true;
        global.note_text = global.active_note.note_text;
    }
}

show_hint = point_distance(x, y, obj_player.x, obj_player.y) < 24;

if (show_hint) {
    global.active_note = id;
} else if (global.active_note == id) {
    global.active_note = noone;
}
