if (sink_factor < 0.99) {
    var tex_w = sprite_get_width(sprite_index);
    var tex_h = sprite_get_height(sprite_index);
    var draw_h = tex_h * (1 - sink_factor);
    var ox = sprite_get_xoffset(sprite_index);
    var oy = sprite_get_yoffset(sprite_index);
    var xx = x - (ox * image_xscale);
    var yy = y - (oy * image_yscale) + (tex_h * image_yscale * sink_factor);

    draw_sprite_part_ext(
        sprite_index, 
        image_index, 
        0, 0,           
        tex_w, draw_h,  
        xx, yy,         
        image_xscale, image_yscale, 
        image_blend, image_alpha
    );
}