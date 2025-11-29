var bar_w = 200;
var bar_h = 20;

var bar_x = display_get_gui_width() - bar_w - 30;
var bar_y = 40;

// border
draw_set_color(c_black);
draw_rectangle(bar_x-2, bar_y-2, bar_x + bar_w + 2, bar_y + bar_h + 2, false);

// smooth fill
var fill = (hp_display / max_hp) * bar_w;
draw_set_color(c_red);
draw_rectangle(bar_x, bar_y, bar_x + fill, bar_y + bar_h, false);
