pulse += 0.05;


// Spawn particles occasionally
if(random(1) < 0.03)
{
    instance_create_layer(
        x + random_range(-15,15),
        y + random_range(-20,20),
        layer,
        obj_portal_particle
    );
}