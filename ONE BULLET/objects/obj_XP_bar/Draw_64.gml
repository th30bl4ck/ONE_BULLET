var bx = 40;  // move right
var by = 60;  // move down
var bw = 150;
var bh = 16;

var current = global.xp;
var max_xp = global.xp_required;
var fill = (current / max_xp) * bw;

// BAR OUTLINE
draw_set_color(c_black);
draw_rectangle(bx - 2, by - 2, bx + bw + 2, by + bh + 2, false);

// BAR BACKGROUND
draw_set_color(make_color_rgb(20, 20, 20));
draw_rectangle(bx, by, bx + bw, by + bh, false);

// BAR FILL
draw_set_color(c_lime);
draw_rectangle(bx, by, bx + fill, by + bh, false);

// LEVEL TEXT ABOVE BAR
draw_set_color(c_white);
draw_text(bx, by - 30, "Level: " + string(global.level));

// XP TEXT BELOW BAR
draw_text(bx, by + bh + 4, string(current) + " / " + string(max_xp) + " XP");

if (global.levelup_active)
{
    var w = display_get_gui_width();
    var h = display_get_gui_height();

    // dark background overlay
    draw_set_color(c_black);
    draw_set_alpha(0.6);
    draw_rectangle(0, 0, w, h, false);
    draw_set_alpha(1);

    // popup window size
    var pw = 300;
    var ph = 150;
    var px = (w/2) - pw/2;
    var py = (h/2) - ph/2;

    // window background
    draw_set_color(make_color_rgb(30, 30, 30));
    draw_rectangle(px, py, px + pw, py + ph, false);

    draw_set_color(c_white);
    draw_text(px + 20, py + 20, "LEVEL UP!");

    draw_text(px + 20, py + 60, "1) " + global.choice_1);
    draw_text(px + 20, py + 90, "2) " + global.choice_2);
}
