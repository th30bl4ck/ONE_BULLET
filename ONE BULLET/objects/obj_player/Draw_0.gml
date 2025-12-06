var should_flash = hit_flash_timer > 0 && (hit_flash_timer mod 4 < 2);

if (should_flash) {
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, image_alpha);
} else {
    draw_self();
}
if (dash_cd_timer > 0) {
    var w = 32;
    var pct = 1 - (dash_cd_timer / dash_cooldown);
    draw_rectangle_colour(x-16, y-24, x-16 + w*pct, y-20, c_white, c_white, c_white, c_white, false);
}
