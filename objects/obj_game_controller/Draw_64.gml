if (!variable_global_exists("debug_room_spawn_open")) exit;
if (!variable_global_exists("debug_room_spawn_names")) exit;
if (!global.debug_room_spawn_open) exit;

var room_count = array_length(global.debug_room_spawn_names);
if (room_count <= 0) exit;

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();
var panel_w = min(560, gui_w - 48);
var panel_h = 132;
var x1 = (gui_w - panel_w) * 0.5;
var y1 = gui_h - panel_h - 32;
var x2 = x1 + panel_w;
var y2 = y1 + panel_h;

draw_set_alpha(0.82);
draw_set_color(c_black);
draw_rectangle(x1, y1, x2, y2, false);

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var index = clamp(global.debug_room_spawn_index, 0, room_count - 1);
draw_text((x1 + x2) * 0.5, y1 + 26, "DEBUG ROOM SPAWNER");
draw_text((x1 + x2) * 0.5, y1 + 64, string(index + 1) + " / " + string(room_count) + "  " + global.debug_room_spawn_names[index]);
draw_text((x1 + x2) * 0.5, y1 + 104, "F9 close   Left/Right choose   Enter spawn");

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
