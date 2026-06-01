if (!variable_global_exists("room_lighting_enabled") || !global.room_lighting_enabled) exit;
if (room == rm_intro || room == main_menu || room == settings_room) exit;

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

var cam = view_camera[0];
if (cam == noone) exit;

var vx = camera_get_view_x(cam);
var vy = camera_get_view_y(cam);
var vw = camera_get_view_width(cam);
var vh = camera_get_view_height(cam);

shader_set(shader_normal_room);
shader_set_uniform_f(global.room_lighting_time_uniform, current_time * 0.001);
shader_set_uniform_f(global.room_lighting_view_pos_uniform, vx, vy);
shader_set_uniform_f(global.room_lighting_view_size_uniform, vw, vh);
shader_set_uniform_f(global.room_lighting_screen_size_uniform, gui_w, gui_h);
shader_set_uniform_f(global.room_lighting_room_size_uniform, room_width, room_height);

draw_set_color(c_white);
draw_set_alpha(1);
gpu_set_blendenable(true);
draw_rectangle(0, 0, gui_w, gui_h, false);

shader_reset();
draw_set_alpha(1);
draw_set_color(c_white);
