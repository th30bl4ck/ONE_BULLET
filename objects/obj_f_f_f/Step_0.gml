if (!instance_exists(obj_enemy_parent))
{
    mode = "follow";

    x = lerp(x, obj_player.x, follow_speed);
    y = lerp(y, obj_player.y, follow_speed);

    move_speed = normal_speed;
}
else
{
    if (mode == "follow")
    {
        start_attack();
    }

    var next_x = x + dir_x * move_speed;
    var next_y = y + dir_y * move_speed;

    if (place_meeting(next_x, y, obj_wall))
    {
        dir_x = -dir_x;
        move_speed *= 0.75;
    }

    if (place_meeting(x, next_y, obj_wall))
    {
        dir_y = -dir_y;
        move_speed *= 0.75;
    }

    x += dir_x * move_speed;
    y += dir_y * move_speed;

    if (move_speed < min_speed)
    {
        start_attack();
    }
}