if (!variable_instance_exists(id, "slowed")) {
    slowed = false;
}

if (slowed) {
    draw_sprite_ext(
        sprite_index,
        image_index,
        x,
        y,
        image_xscale,
        image_yscale,
        image_angle,
        c_gray,
        image_alpha
    );
} else {
    draw_self();
}