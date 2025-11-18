// Player walks over bullet to pick it up
if (state == "stuck" && owner != noone) {
    with (owner) {
        can_shoot = true;
        bullet_id = noone;
    }
    instance_destroy();
}
