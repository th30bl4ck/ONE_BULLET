state = "fired";
speed = 10;
if (!variable_global_exists("recall_speed")) {
    global.recall_speed = 6;
}
image_angle = direction;
owner = other;
solid = false;

image_angle = direction - 90;


orbit_angle = irandom_range(0, 359);
orbit_speed = 8;
orbit_radius = 24;
