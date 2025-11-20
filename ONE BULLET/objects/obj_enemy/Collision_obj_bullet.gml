instance_destroy(other); // kill the bullet
instance_destroy();      // kill the enemy

// Return shooting ability
with (obj_player) {
    can_shoot = true;
    bullet_id = noone;
}

var p = instance_create_layer(x, y, layer, obj_scorepopup);
p.value = 10;

