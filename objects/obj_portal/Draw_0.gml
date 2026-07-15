var pulse_amount = sin(pulse) * 0.04;

var scale_x = 1 + pulse_amount;
var scale_y = 1 - pulse_amount * 0.5;


// Green glow

gpu_set_blendmode(bm_add);

for (var i = 4; i > 0; i--)
{
    draw_sprite_ext(
        sprite_index,
        image_index,
        x,
        y,
        scale_x + i * 0.04,
        scale_y + i * 0.04,
        rotation,
        make_color_rgb(40,255,40),
        0.06
    );
}


// Inner glow pulse

draw_sprite_ext(
    sprite_index,
    image_index,
    x,
    y,
    scale_x,
    scale_y,
    rotation,
    make_color_rgb(120,255,80),
    0.25 + sin(pulse)*0.05
);


gpu_set_blendmode(bm_normal);


// Main portal

draw_sprite_ext(
    sprite_index,
    image_index,
    x,
    y,
    scale_x,
    scale_y,
    rotation,
    c_white,
    1
);


// Heat distortion waves

draw_set_alpha(0.04);

for(var i = 0; i < 3; i++)
{
    var offset = sin(current_time/200+i)*5;

    draw_sprite_ext(
        sprite_index,
        image_index,
        x + offset,
        y,
        scale_x + i*0.15,
        scale_y + i*0.15,
        rotation,
        c_white,
        0.15
    );
}

draw_set_alpha(1);