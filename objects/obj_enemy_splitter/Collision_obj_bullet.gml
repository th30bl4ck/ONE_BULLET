var bullet_pierces = variable_global_exists("bullet_pierce") && global.bullet_pierce;

if (!bullet_pierces) {
    instance_destroy(other); // kill the bullet
}

var spawn_offset = 20;

for (var i = 0; i < 2; i++)
{
    var angle = irandom_range(0, 359);
    var nx = x + lengthdir_x(spawn_offset, angle);
    var ny = y + lengthdir_y(spawn_offset, angle);
   
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