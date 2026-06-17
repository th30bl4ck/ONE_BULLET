function scr_random_item(){
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
		
    alexs_arsanal: {
		name: "alexs_arsanal",
		sprite_index: spr_alexs_arsanal,
		object_index: obj_alexs_arsanal
       	},
		
		f_f_f: {
			name: "f_f_f",
			sprite_index: spr_fantastic_flesh_fel,
			object_index: obj_f_f_f_in_shop
		},
        
        liquid_lead: {
            name: "liquid_lead",
            sprite_index: spr_liquid_lead,
            object_index: obj_liquid_lead
           
        },
    
};

var item = choose(
    global.items.pierce,
    global.items.the_jerk,
    global.items.alexs_arsanal,
    global.items.f_f_f,
    global.items.liquid_lead
);
instance_create_layer(x, y, "Instances", item.object_index);
instance_destroy();

    return item
}