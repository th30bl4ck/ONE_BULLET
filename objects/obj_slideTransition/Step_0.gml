// Capture old room surface once
if (surf_old == -1) {
    surf_old = surface_create(w, h);
    surface_set_target(surf_old);
    draw_surface(application_surface, 0, 0);  // captures starting_room correctly
    surface_reset_target();
}

// Capture next room surface once target_room exists
if (surf_new == -1 && variable_instance_exists(id, "target_room") && target_room != noone) {
    room_goto(target_room);       // temporarily switch to next room
    surf_new = surface_create(w, h);
    surface_set_target(surf_new);
    draw_surface(application_surface, 0, 0);
    surface_reset_target();
    room_goto_previous();         // back to starting_room
}

// Slide both surfaces
offset += slide_speed;

// When fully slid, actually switch rooms
if (offset >= w && surf_new != -1) {
    room_goto(target_room);
    instance_destroy();
}
