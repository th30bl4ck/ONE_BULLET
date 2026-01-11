if (game_pause) {
    var coin_text = "Coins: " + string(global.coins);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_text(16, 16, coin_text);

    if (variable_global_exists("upgrade_counts"))
    {
        var upgrades = [
            "rollershoes",
            "medkit",
            "stim",
            "Sticky Finger",
            "Big Boy Boots"
        ];

        var base_x = 16;
        var base_y = display_get_gui_height() - 16;
        var line_height = 20;
        var draw_index = 0;

        draw_set_halign(fa_left);
        draw_set_valign(fa_bottom);
        draw_set_color(c_white);
        draw_text(base_x, base_y, "Upgrades:");

        draw_set_valign(fa_middle);

        for (var i = 0; i < array_length(upgrades); i++)
        {
            var upgrade_name = upgrades[i];
            if (!ds_map_exists(global.upgrade_counts, upgrade_name))
                continue;

            var count = global.upgrade_counts[? upgrade_name];
            if (count <= 0)
                continue;

            draw_index += 1;
            var entry_y = base_y - (line_height * draw_index);
            var icon_x = base_x;
            var text_x = base_x + 24;
            var label = upgrade_name;

            if (count > 1)
            {
                label += " x" + string(count);
            }

            if (variable_global_exists("upgrade_icons"))
            {
                if (ds_map_exists(global.upgrade_icons, upgrade_name))
                {
                    var icon = global.upgrade_icons[? upgrade_name];
                    draw_sprite(icon, 0, icon_x, entry_y);
                }
            }

            draw_text(text_x, entry_y, label);
        }
    }

    var text = "Game Paused";
    var text_x = display_get_gui_width() / 2;
    var text_y = display_get_gui_height() / 2;

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(text_x, text_y, text);
}
