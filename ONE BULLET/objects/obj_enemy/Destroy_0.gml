global.score += 10;

for (var i = 0; i < 3; i++) {
    var xx = x + irandom_range(-16, 16);
    var yy = y + irandom_range(-16, 16);
    instance_create_layer(xx, yy, "Instances", obj_XP);
}
