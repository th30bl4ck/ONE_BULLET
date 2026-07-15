if (slow_timer > 0) {
    slow_timer--;
    slowed = true;
} else {
    slowed = false;
    slow_multiplier = 1;
}

x += hsp;
y += vsp;

hsp *= 0.85;
vsp *= 0.85;
{
    instance_destroy();
}

if (hp <= 0)
{
    instance_destroy();
}