var bullet_pierces = variable_global_exists("bullet_pierce") && global.bullet_pierce;

if (!bullet_pierces) {
    instance_destroy(other); 
}

instance_destroy();      

// Return shooting ability
if (!bullet_pierces) {
    with (obj_player) {
        can_shoot = true;
        bullet_id = noone;
    }
}
