life--;

with (obj_enemy_parent) {
    if (point_distance(x, y, other.x, other.y) < other.radius) {
        hp -= other.damage;

        slowed = true;
        slow_timer = 10;
        slow_multiplier = other.slow_amount;
    }
}

if (life <= 0) {
    instance_destroy();
}