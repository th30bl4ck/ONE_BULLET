draw_self();
if (dash_cd_timer > 0) {
    var w = 32;
    var pct = 1 - (dash_cd_timer / dash_cooldown);
    draw_rectangle_colour(x-16, y-24, x-16 + w*pct, y-20, c_white, c_white, c_white, c_white, false);
}
