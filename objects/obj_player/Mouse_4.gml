if (can_shoot) {
    var inst = instance_create_layer(x, y, "Instances", obj_bullet);
    inst.direction = point_direction(x, y, mouse_x, mouse_y);
    inst.speed = 10;

    can_shoot = false;
    bullet_id = inst;
}
