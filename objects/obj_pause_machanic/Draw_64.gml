if (!game_pause) exit;

// ===============================
// TOP-LEFT: COINS
// ===============================
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);

draw_text(16, 16, "Coins: " + string(global.coins));


// ===============================
// BOTTOM-LEFT: UPGRADES LIST 
// ===============================
if (variable_global_exists("upgrade_counts") && global.upgrade_counts != noone)
{
    // These MUST match your ds_map keys exactly:
    var upgrades = [
        "rollershoes",
        "medkit",
        "stim",
        "Sticky Finger",
        "Big Boy Boots"
    ];

    var base_x = 50;
    var bottom_y = display_get_gui_height() - 32;

    var pad = 4;          // padding inside each row
    var icon_gap = 8;     // space between icon and text
    var icon_size_fallback = 16;

   
    var cursor_y = bottom_y;

    draw_set_halign(fa_left);
    draw_set_color(c_white);

    // ----- Header -----
    var header = "Upgrades:";
    var header_h = string_height(header);

    var header_top = cursor_y - header_h;
    draw_set_valign(fa_top);
    draw_text(base_x, header_top, header);

    cursor_y = header_top - pad;

    // ----- Entries -----
    for (var i = 0; i < array_length(upgrades); i++)
    {
        var upgrade_name = upgrades[i];

        if (!ds_map_exists(global.upgrade_counts, upgrade_name))
            continue;

        var count = global.upgrade_counts[? upgrade_name];
        if (count <= 0)
            continue;

        var label = upgrade_name;
        if (count > 1) label += " x" + string(count);

        // text height
        var text_h = string_height(label);

        // icon sprite (if exists)
        var icon = noone;
        var icon_h = icon_size_fallback;

        if (variable_global_exists("upgrade_icons") && global.upgrade_icons != noone)
        {
            if (ds_map_exists(global.upgrade_icons, upgrade_name))
            {
                icon = global.upgrade_icons[? upgrade_name];
                if (icon != noone && !is_undefined(icon))
                {
                    icon_h = sprite_get_height(icon);
                }
            }
        }

        // row height
        var row_h = max(text_h, icon_h) + pad;

        // row top
        var row_top = cursor_y - row_h;

        // center icon + text in row
        var icon_y = row_top + (row_h - icon_h) * 0.5;
        var text_y = row_top + (row_h - text_h) * 0.5;

        var icon_x = base_x;
        var text_x = base_x + icon_size_fallback + icon_gap;

        // draw icon
        if (icon != noone)
        {
            draw_sprite(icon, 0, icon_x, icon_y);
        }

        // draw text
        draw_set_valign(fa_top);
        draw_text(text_x, text_y, label);

        // move up
        cursor_y = row_top;
    }
}


// ===============================
// CENTER: PAUSED TEXT
// ===============================
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);

draw_text(
    display_get_gui_width() * 0.5,
    display_get_gui_height() * 0.5,
    "Game Paused"
);
