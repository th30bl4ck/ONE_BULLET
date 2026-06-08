if (!view_enabled) exit;
if (!view_visible[0]) exit;

var cam = view_camera[0];
if (cam == -1) exit;

var cam_w = camera_get_view_width(cam);
var cam_h = camera_get_view_height(cam);
var target_x = camera_get_view_x(cam);
var target_y = camera_get_view_y(cam);

if (instance_exists(obj_player))
{
    var player = instance_find(obj_player, 0);

    if (!variable_instance_exists(player, "state") || player.state != "dying")
    {
        target_x = player.x - cam_w * 0.5;
        target_y = player.y - cam_h * 0.5;
    }
}

var max_x = max(0, room_width - cam_w);
var max_y = max(0, room_height - cam_h);

camera_set_view_pos(cam, clamp(target_x, 0, max_x), clamp(target_y, 0, max_y));
