sprite_index = noone;

global.items = {
    pierce: {
        name: "Pierce",
        sprite_index: spr_perice,
        object_index: obj_perice
        },
        
    the_jerk: {
        name: "The jerk",
        sprite_index: spr_the_jerk,
        object_index: obj_the_jerk
        },
    
    
};

var item = choose(global.items.pierce, global.items.the_jerk);
instance_create_layer(x, y, "Instances", item.object_index);
instance_destroy();
