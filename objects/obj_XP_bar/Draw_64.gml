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

// -------------------------------------------------
// helper: draw rounded panel (NO draw_roundrect)
// -------------------------------------------------
function draw_panel_rounded(x1, y1, x2, y2, r, fill_col, outline_col)
{
    r = clamp(r, 0, min((x2 - x1) * 0.5, (y2 - y1) * 0.5));

    // fill
    draw_set_color(fill_col);
    draw_rectangle(x1 + r, y1,     x2 - r, y2,     false);
    draw_rectangle(x1,     y1 + r, x2,     y2 - r, false);

    draw_circle(x1 + r, y1 + r, r, false);
    draw_circle(x2 - r, y1 + r, r, false);
    draw_circle(x1 + r, y2 - r, r, false);
    draw_circle(x2 - r, y2 - r, r, false);

    // outline
    draw_set_color(outline_col);
    draw_line(x1 + r, y1,     x2 - r, y1);
    draw_line(x1 + r, y2,     x2 - r, y2);
    draw_line(x1,     y1 + r, x1,     y2 - r);
    draw_line(x2,     y1 + r, x2,     y2 - r);

    draw_circle(x1 + r, y1 + r, r, true);
    draw_circle(x2 - r, y1 + r, r, true);
    draw_circle(x1 + r, y2 - r, r, true);
    draw_circle(x2 - r, y2 - r, r, true);
}

// -------------------------------------------------
// helper: circle with clean black outline (no green bleed)
// -------------------------------------------------
function draw_accent_circle(x, y, r, fill_col)
{
    var rf = max(1, r - 1);

    // fill
    draw_set_color(fill_col);
    draw_circle(x, y, rf, false);

    // outline (WHITE)
    draw_set_color(c_white);
    draw_circle(x, y, r, true);
}

// -------------------------------------------------
// Layout
// -------------------------------------------------
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

var cx = gui_w * 0.5;
var cy = gui_h * 0.5;

var panel_w = 900;
var panel_h = 520;

var left   = cx - panel_w * 0.5;
var right  = cx + panel_w * 0.5;
var top    = cy - panel_h * 0.5;
var bottom = cy + panel_h * 0.5;

var pad = 50;

var s_title = 2.0;
var s_text  = 1.55;

// selection (optional)
var sel = 1;
if (variable_global_exists("levelup_sel")) sel = global.levelup_sel;

// -------------------------------------------------
// Colors
// -------------------------------------------------
var panel_fill_col  = make_color_rgb(70, 120, 70);     // green panel background
var circle_fill_col = make_color_rgb(170, 225, 180);   // same fill for ALL circles
var option_fill_col = make_color_rgb(220, 230, 220);   // option rectangles same colour
var text_col        = make_color_rgb(10, 20, 10);      // dark text

// -------------------------------------------------
// Reset draw state
// -------------------------------------------------
draw_set_alpha(1);
draw_set_color(c_white);
shader_reset();
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// -------------------------------------------------
// Dim background
// -------------------------------------------------
draw_set_color(c_black);
draw_set_alpha(0.60);
draw_rectangle(0, 0, gui_w, gui_h, false);
draw_set_alpha(1);

// -------------------------------------------------
// Main panel (GREEN)
// -------------------------------------------------
draw_panel_rounded(left, top, right, bottom, 18, panel_fill_col, c_black);

// -------------------------------------------------
// Panel corner accents (clean outline)
// -------------------------------------------------
var cr   = 12;  // radius
var coff = 18;  // offset from corners

draw_accent_circle(left + coff,  top + coff,    cr, circle_fill_col);
draw_accent_circle(right - coff, top + coff,    cr, circle_fill_col);
draw_accent_circle(left + coff,  bottom - coff, cr, circle_fill_col);
draw_accent_circle(right - coff, bottom - coff, cr, circle_fill_col);

// -------------------------------------------------
// Divider + title
// -------------------------------------------------
draw_set_color(c_black);
draw_line_width(left + pad, top + 125, right - pad, top + 125, 3);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_color(text_col);
draw_text_transformed(cx, top + 80, "LEVEL UP!", s_title, s_title, 0);

// -------------------------------------------------
// Options
// -------------------------------------------------
var opt_y   = top + 270;
var opt_gap = 280;

var opt1_x = cx - opt_gap;
var opt2_x = cx + opt_gap;

var box_w = 320;
var box_h = 140;
var box_r = 14;

for (var i = 1; i <= 2; i++)
{
    var ox = (i == 1) ? opt1_x : opt2_x;

    var bx1 = ox - box_w * 0.5;
    var by1 = opt_y - box_h * 0.5;
    var bx2 = ox + box_w * 0.5;
    var by2 = opt_y + box_h * 0.5;

    // option rectangles: SAME colour
    draw_panel_rounded(bx1, by1, bx2, by2, box_r, option_fill_col, c_black);

    // option corner accents: SAME fill + clean black outline
    var oc_r = (i == sel) ? 11 : 9;  // subtle selection feedback
    var oc_o = 14;

    draw_accent_circle(bx1 + oc_o, by1 + oc_o, oc_r, circle_fill_col);
    draw_accent_circle(bx2 - oc_o, by1 + oc_o, oc_r, circle_fill_col);
    draw_accent_circle(bx1 + oc_o, by2 - oc_o, oc_r, circle_fill_col);
    draw_accent_circle(bx2 - oc_o, by2 - oc_o, oc_r, circle_fill_col);
}

// -------------------------------------------------
// Icons
// -------------------------------------------------
var icon1 = noone;
var icon2 = noone;

if (ds_map_exists(global.upgrade_icons, global.choice_1))
    icon1 = global.upgrade_icons[? global.choice_1];

if (ds_map_exists(global.upgrade_icons, global.choice_2))
    icon2 = global.upgrade_icons[? global.choice_2];

var icon_y = opt_y - 40;
var icon_scale = 2; 

draw_sprite_ext(icon1, 0, opt1_x, icon_y, icon_scale, icon_scale, 0, c_white, 1);
draw_sprite_ext(icon2, 0, opt2_x, icon_y, icon_scale, icon_scale, 0, c_white, 1);

// -------------------------------------------------
// Option text
// -------------------------------------------------
draw_set_halign(fa_center);
draw_set_color(text_col);

draw_text_transformed(opt1_x, opt_y + 35, "1) " + string(global.choice_1), s_text, s_text, 0);
draw_text_transformed(opt2_x, opt_y + 35, "2) " + string(global.choice_2), s_text, s_text, 0);

// -------------------------------------------------
// Hint
// -------------------------------------------------
draw_set_alpha(0.90);
draw_text_transformed(cx, bottom - 55, "Press 1 / 2 to choose", 1.2, 1.2, 0);

// -------------------------------------------------
// Restore state
// -------------------------------------------------
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
