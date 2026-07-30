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

var available_items = ds_list_create();
ds_list_add(available_items, global.items.pierce);
ds_list_add(available_items, global.items.the_jerk);
ds_list_add(available_items, global.items.alexs_arsanal);
ds_list_add(available_items, global.items.f_f_f);
ds_list_add(available_items, global.items.JS);
ds_list_add(available_items, global.items.exorsizm);
ds_list_add(available_items, global.items.semantic_orbit);
ds_list_add(available_items, global.items.trickshot);

var remove_used_item = function(_available_items, _used_item) {
    if (_used_item == noone || _used_item == -1) {
        return;
    }

    for (var i = ds_list_size(_available_items) - 1; i >= 0; i--) {
        if (_available_items[| i].object_index == _used_item.object_index) {
            ds_list_delete(_available_items, i);
            return;
        }
    }
};

remove_used_item(available_items, global.shop_item_1);
remove_used_item(available_items, global.shop_item_2);
remove_used_item(available_items, global.shop_item_3);
remove_used_item(available_items, global.shop_item_4);
remove_used_item(available_items, global.shop_item_5);
remove_used_item(available_items, global.shop_item_6);
remove_used_item(available_items, global.shop_item_7);
remove_used_item(available_items, global.shop_item_8);

if (ds_list_size(available_items) <= 0) {
    ds_list_destroy(available_items);
    return -1;
}

var item = available_items[| irandom(ds_list_size(available_items) - 1)];
ds_list_destroy(available_items);

    return item
}
