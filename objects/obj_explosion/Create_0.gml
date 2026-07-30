radius = 150;
inner_radius = 50;

explosion_damage = 20;
push_force = 16;

life = 20;
max_life = life;

with (obj_enemy_parent)
{
    var dist = point_distance(x, y, other.x, other.y);

    if (dist <= other.radius)
    {
        var dir = point_direction(other.x, other.y, x, y);

        // inner explosion = damage
        if (dist <= other.inner_radius)
        {
            hp -= other.explosion_damage;
            show_debug_message("Explosion damaged enemy. HP: " + string(hp));
        }

        // whole explosion = push
        x += lengthdir_x(other.push_force, dir);
        y += lengthdir_y(other.push_force, dir);

        if (hp <= 0)
        {
            instance_destroy();
        }
    }
}