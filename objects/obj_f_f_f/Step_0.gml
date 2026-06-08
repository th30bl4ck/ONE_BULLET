var enemy_count = instance_number(obj_enemy_parent);

// If moving, bounce around like DVD logo
if (is_moving)
{
    x += hsp;
    y += vsp;

    // Bounce off room left/right walls
    if (x <= 0)
    {
        x = 0;
        hsp = abs(hsp);
        image_xscale = 1; // face right
    }

    if (x >= room_width - sprite_width)
    {
        x = room_width - sprite_width;
        hsp = -abs(hsp);
        image_xscale = -1; // face left
    }

    // Bounce off top/bottom walls
    if (y <= 0)
    {
        y = 0;
        vsp = abs(vsp);
        // Do NOT change sprite direction vertically
    }

    if (y >= room_height - sprite_height)
    {
        y = room_height - sprite_height;
        vsp = -abs(vsp);
        // Do NOT change sprite direction vertically
    }

    // Slowly lose speed over time
    var current_speed = point_distance(0, 0, hsp, vsp);

    if (current_speed > 0)
    {
        var new_speed = max(current_speed - friction_amount, 0);

        if (new_speed <= 0.05)
        {
            hsp = 0;
            vsp = 0;
            is_moving = false;
        }
        else
        {
            var dir = point_direction(0, 0, hsp, vsp);
            hsp = lengthdir_x(new_speed, dir);
            vsp = lengthdir_y(new_speed, dir);
        }
    }
}
else
{
    // If stopped and enemies exist, launch in random direction
    if (enemy_count > 0)
    {
        var dir = irandom_range(0, 359);

        hsp = lengthdir_x(move_speed, dir);
        vsp = lengthdir_y(move_speed, dir);

        if (hsp >= 0)
        {
            image_xscale = 1;
        }
        else
        {
            image_xscale = -1;
        }

        is_moving = true;
    }
    else
    {
        // No enemies, follow player with delay
        x = lerp(x, obj_player.x, follow_speed);
        y = lerp(y, obj_player.y, follow_speed);
    }
}
