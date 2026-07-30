if (state == "dead") exit;

if (!variable_global_exists("alexs_arsanal")) global.alexs_arsanal = false;
if (!variable_global_exists("bullet_pierce")) global.bullet_pierce = false;

var bullet_pierces = global.bullet_pierce;
var bullet_moving = other.state == "fired" || other.state == "recall";

if (!bullet_moving) exit;

hp -= other.damage;
hit_flash_timer = 8;

if (global.alexs_arsanal)
{
    instance_create_layer(other.x, other.y, other.layer, obj_explosion);
}

if (bullet_pierces)
{
    if (hp > 0)
    {
        other.speed = 0;
        other.hspeed = 0;
        other.vspeed = 0;
        other.state = "stopped";
    }
}
else
{
    with (obj_player)
    {
        bullet_id = noone;
        bullet_pickup_shoot_timer = bullet_pickup_shoot_delay;
        can_shoot = false;
    }

    instance_destroy(other);
}
