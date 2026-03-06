var orbit_bullet = variable_instance_exists(other, "state") && other.state == "orbit";
var bullet_pierces = (variable_global_exists("bullet_pierce") && global.bullet_pierce) || orbit_bullet;

if (!bullet_pierces) {
    instance_destroy(other); // kill the bullet
}

var spawn_offset = 20;

for (var i = 0; i < 2; i++)
{
    var angle = irandom_range(0, 359);
    var nx = x + lengthdir_x(spawn_offset, angle);
    var ny = y + lengthdir_y(spawn_offset, angle);

    var obj_to_spawn;

    if (i == 0)
        obj_to_spawn = obj_enemy_splitter_kids;
    else
        obj_to_spawn = obj_enemy_splitter_kids_1;

    instance_create_layer(nx, ny, "Instances", obj_to_spawn);
}

instance_destroy(); // kill the enemy

instance_destroy();      // kill the enemy

// Return shooting ability
if (!bullet_pierces) {
    with (obj_player) {
        can_shoot = true;
        bullet_id = noone;
    }
}