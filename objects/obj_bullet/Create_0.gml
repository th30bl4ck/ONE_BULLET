state = "fired"; 
speed = 10;
if (!variable_global_exists("recall_speed")) {
    global.recall_speed = 6;
}
image_angle = direction; 
owner = other; 
solid = false; 

image_angle = direction - 90;

