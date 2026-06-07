x += lengthdir_x(mouse_speed, mouse_dir);
y += lengthdir_y(mouse_speed, mouse_dir);

if (place_meeting(x, y, obj_wall))
{
    instance_destroy();
    exit;
}

mouse_life--;
if (mouse_life <= 0 || x < -64 || x > room_width + 64 || y < -64 || y > room_height + 64)
{
    instance_destroy();
}
