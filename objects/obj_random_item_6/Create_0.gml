var item = noone; 

if (global.shop_item_6 == noone) {
item = scr_random_item();

global.shop_item_6 = item;
}
else {
    instance_create_layer(x, y, "Instances", global.shop_item_6.object_index);
    instance_destroy();
}