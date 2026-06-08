var t = 1 - (life / max_life);
var r = radius * t;
var alpha = life / max_life;

draw_set_alpha(alpha);

draw_set_color(c_orange);
draw_circle(x, y, r, false);

draw_set_color(c_yellow);
draw_circle(x, y, r * 0.6, false);

draw_set_color(c_red);
draw_circle(x, y, r * 0.3, false);

draw_set_alpha(1);