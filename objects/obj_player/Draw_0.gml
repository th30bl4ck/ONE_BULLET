var should_flash = hit_flash_timer > 0 && (hit_flash_timer mod 4 < 2);

if (should_flash) {
    // Tint the sprite red and lower alpha to make the hit state obvious
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_red, 0.5);
} else {
    draw_self();
}
if (dash_cd_timer > 0) {
    var w = 32;
    var pct = 1 - (dash_cd_timer / dash_cooldown);
    draw_rectangle_colour(x-16, y-24, x-16 + w*pct, y-20, c_white, c_white, c_white, c_white, false);
}

if (combo_count > 1) {

    var bar_w = 24;
    var bar_h = 4;

    var bar_x = x - bar_w / 2;
    var bar_y = bbox_bottom + 4; // BELOW the player

    var pct = combo_timer / combo_timer_max;

    // Background
    draw_set_alpha(0.5);
    draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, false);

    // Heat-based color
    var col = merge_colour(c_yellow, c_red, combo_heat);

    draw_set_alpha(1);
    draw_set_colour(col);
    draw_rectangle(
        bar_x,
        bar_y,
        bar_x + (bar_w * pct),
        bar_y + bar_h,
        false
    );

    // Combo number under bar
    draw_text(x, bar_y + 6, "x" + string(combo_count));
}


