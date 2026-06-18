
var item = noone; 
shop_item_slot = 0

switch (object_index) {
	case obj_random_item_1:
        shop_item_slot = 1;
        shop_item = global.shop_item_1; 
        break;
    case obj_random_item_2:
        shop_item_slot = 1;
        shop_item = global.shop_item_2; 
        break;
    case obj_random_item_3:
        shop_item_slot = 1;
        shop_item = global.shop_item_3; 
        break;
    case obj_random_item_4:
        shop_item_slot = 1;
        shop_item = global.shop_item_4; 
        break;
    case obj_random_item_5:
        shop_item_slot = 1;
        shop_item = global.shop_item_5; 
        break;
    case obj_random_item_6:
        shop_item_slot = 1;
        shop_item = global.shop_item_6; 
        break;
    case obj_random_item_7:
        shop_item_slot = 1;
        shop_item = global.shop_item_7; 
        break;
    case obj_random_item_8:
        shop_item_slot = 1;
        shop_item = global.shop_item_8; 
        break;
}

if (shop_item == noone){
    shop_item = scr_random_item();
      switch (shop_item_slot){
            case 1: global.shop_item_1 = -1; break;
            case 2: global.shop_item_2 = -1; break;
            case 3: global.shop_item_3 = -1; break;
            case 4: global.shop_item_4 = -1; break;
            case 5: global.shop_item_5 = -1; break;
            case 6: global.shop_item_6 = -1; break;
            case 7: global.shop_item_7 = -1; break;
            case 8: global.shop_item_8 = -1; break; 
        }
}

if (shop_item == -1){
    instance_destroy();
    exit;
}

var spawned_item = instance_create_layer(x, y, "Instances", shop_item.object_index);
spawned_item.shop_item_slot = shop_item_slot;
instance_destroy();