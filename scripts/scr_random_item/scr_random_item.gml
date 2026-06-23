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
			object_index: obj_f_f_f
		},
        
    JS: {
        name: "Jogging Shorts",
        sprite_index: spr_jogging_shorts,
        object_index: obj_JS
    },
    
    exorsizm: {
        name: "Exorsizm",
        sprite_index: spr_exorsizm,
        object_index: obj_exorsizm
    },
    
    semantic_orbit: {
        name: "Semantic Orbit",
        sprite_index: spr_semantic_orbit,
        object_index: obj_semantic_orbit
    },
    
    trickshot: {
        name: "Trickshot",
        sprite_index: spr_trickshot,
        object_index: obj_trickshot
    },
};

var item = choose(
    global.items.pierce,
    global.items.the_jerk,
    global.items.alexs_arsanal,
    global.items.JS,
    global.items.exorsizm,
    global.items.semantic_orbit,
    global.items.trickshot,
);

    return item
}