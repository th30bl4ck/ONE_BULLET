radius = 96;
inner_radius = 60;

damage = 20;
push_force = 8;

life = 12;
max_life = life;

// damage enemies once
with (obj_enemy) {
    var dist = point_distance(x, y, other.x, other.y);

    if (dist <= other.radius) {
        var dir = point_direction(other.x, other.y, x, y);

        if (dist <= other.inner_radius) {
            hp -= other.damage;
            x += lengthdir_x(other.push_force, dir);
            y += lengthdir_y(other.push_force, dir);
        } else {
            x += lengthdir_x(other.push_force * 1.5, dir);
            y += lengthdir_y(other.push_force * 1.5, dir);
        }
    }
}
