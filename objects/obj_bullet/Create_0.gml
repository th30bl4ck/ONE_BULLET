state = "fired";
speed = 10;

if (!variable_global_exists("recall_speed")) {
    global.recall_speed = 6;
}

owner = noone;
solid = false;

orbit_angle = 0;
orbit_speed = 6;
orbit_radius = 32;

image_angle = direction - 90;