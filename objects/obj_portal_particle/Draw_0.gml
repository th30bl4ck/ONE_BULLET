gpu_set_blendmode(bm_add);

draw_set_color(make_color_rgb(50,255,50));

draw_circle(
    x,
    y,
    size,
    false
);

gpu_set_blendmode(bm_normal);

draw_set_color(c_white);