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
