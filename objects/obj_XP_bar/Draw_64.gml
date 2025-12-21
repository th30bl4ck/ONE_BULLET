// =====================
// BAR POSITION (FIXED)
// =====================
var bx = 40;
var by = 60;
var bw = 150;
var bh = 16;

// =====================
// XP VALUES
// =====================
var current = global.xp;
var max_xp = global.xp_required;
var fill = clamp((current / max_xp) * bw, 0, bw);

// =====================
// BAR OUTLINE
// =====================
draw_set_color(c_black);
draw_rectangle(bx - 2, by - 2, bx + bw + 2, by + bh + 2, false);

// =====================
// BAR BACKGROUND
// =====================
draw_set_color(make_color_rgb(20, 20, 20));
draw_rectangle(bx, by, bx + bw, by + bh, false);

// =====================
// BAR FILL
// =====================
draw_set_color(c_lime);
draw_rectangle(bx, by, bx + fill, by + bh, false);

// =====================
// TEXT SETTINGS (CRITICAL)
// =====================
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);

// =====================
// LEVEL TEXT (LOCKED POSITION)
// =====================
draw_text(bx, by - 34, "Level: " + string(global.level));

// =====================
// XP TEXT (LOCKED POSITION)
// =====================
draw_text(bx, by + bh + 3,
    string(current) + " / " + string(max_xp) + " XP"
);




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


var icon_offset = 120;
var icon_y = cy - 20;


var icon1 = noone;
var icon2 = noone;

if (ds_map_exists(global.upgrade_icons, global.choice_1))
    icon1 = global.upgrade_icons[? global.choice_1];

if (ds_map_exists(global.upgrade_icons, global.choice_2))
    icon2 = global.upgrade_icons[? global.choice_2];

// Draw only if valid
if (icon1 != noone)
    draw_sprite(icon1, 0, cx - icon_offset, icon_y);

if (icon2 != noone)
    draw_sprite(icon2, 0, cx + icon_offset, icon_y);
