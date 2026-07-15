if (state == "dead") exit;

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

var bar_w = 420;
var bar_h = 28;
var bar_x = (gui_w - bar_w) * 0.5;
var bar_y = gui_h - 64;
var hp_ratio = clamp(hp / max_hp, 0, 1);
var fill_w = bar_w * hp_ratio;

draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_color(c_white);
draw_text(gui_w * 0.5, bar_y - 8, boss_name);

// back plate
draw_set_color(make_color_rgb(28, 24, 22));
draw_rectangle(bar_x - 3, bar_y - 3, bar_x + bar_w + 3, bar_y + bar_h + 3, false);

// empty track
draw_set_color(make_color_rgb(60, 40, 40));
draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, false);

// green health fill
if (fill_w > 0)
{
    draw_set_color(make_color_rgb(70, 200, 80));
    draw_rectangle(bar_x, bar_y, bar_x + fill_w, bar_y + bar_h, false);

    // lighter top edge so it reads as a fill, not a flat block
    draw_set_color(make_color_rgb(130, 235, 120));
    draw_rectangle(bar_x, bar_y, bar_x + fill_w, bar_y + 6, false);
}

// border
draw_set_color(c_white);
draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, true);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
