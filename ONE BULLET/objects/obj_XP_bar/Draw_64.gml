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
draw_text(bx, by - 35, "Level: " + string(global.level));

// XP TEXT BELOW BAR
draw_text(bx, by + bh + 4, string(current) + " / " + string(max_xp) + " XP");


if (!global.levelup_active) exit;

var cx = display_get_gui_width() * 0.5;
var cy = display_get_gui_height() * 0.5;

// RESET EVERYTHING IMPORTANT
draw_set_alpha(1);
draw_set_color(c_white);
shader_reset();

// --- WHITE BOX ---
draw_rectangle(cx - 220, cy - 120, cx + 220, cy + 120, false);

// --- BLACK OUTLINE ---
draw_set_color(c_black);
draw_rectangle(cx - 220, cy - 120, cx + 220, cy + 120, true);

// --- BLACK TEXT ---
draw_set_alpha(1);
draw_set_color(c_black);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_text(cx, cy - 70, "LEVEL UP!");

draw_set_halign(fa_right);
draw_text(cx - 40, cy, "1) " + string(global.choice_1));

draw_set_halign(fa_left);
draw_text(cx + 40, cy, "2) " + string(global.choice_2));
