
var item = noone; 

shop_item = item;

if (shop_item == noone) {
item = scr_random_item();
}
else {
    instance_create_layer(x, y, "Instances", shop_item.object_index);
    instance_destroy();
}