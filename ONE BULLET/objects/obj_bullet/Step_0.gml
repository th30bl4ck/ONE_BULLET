// Keep sprite facing travel direction (optional)
image_angle = direction;

// If fired - normal physics handled by speed & direction

// Prevent instant wall-destroy if you want spawn-in-wall safety:
if (state == "fired") {
    // if colliding with wall right away, nudge it out instead of destroying
    if (place_meeting(x, y, obj_wall)) {
        // try nudging outward a bit
        x += lengthdir_x(4, direction);
        y += lengthdir_y(4, direction);
        // if still inside wall after a couple frames you could destroy, but this prevents instant death
    }
}

// Basic returning handled separately; leaving for Step 3, but ensure bullet doesn't self-destruct yet
// If stuck, do nothing
if (state == "stuck") {
    speed = 0;
    exit;
}

// Otherwise, fired state moves automatically using speed & direction
