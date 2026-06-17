var fade = life / life_max;

draw_set_alpha(fade * 0.6);
draw_set_color(c_gray);
draw_circle(x, y, radius, false);

draw_set_alpha(1);
draw_set_color(c_white);