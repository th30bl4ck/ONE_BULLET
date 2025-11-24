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
