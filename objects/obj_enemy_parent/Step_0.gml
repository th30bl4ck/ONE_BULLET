x += hsp;
y += vsp;

hsp *= 0.85;
vsp *= 0.85;

if (hp <= 0)
{
    instance_destroy();
}