var item = noone; 

if (global.shop_item_4 == noone) {
item = scr_random_item();

global.shop_item_4 = item;
}
else {
    instance_create_layer(x, y, "Instances", global.shop_item_4.object_index);
    instance_destroy();
}