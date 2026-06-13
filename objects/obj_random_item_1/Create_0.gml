var item = noone; 

if (global.shop_item_1 == noone) {
item = scr_random_item();

global.shop_item_1 = item;
}
else {
instance_create_layer(x, y, "Instances", global.shop_item_1.object_index);
}