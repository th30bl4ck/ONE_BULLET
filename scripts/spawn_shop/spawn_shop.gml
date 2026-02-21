function spawn_shop()
{
    var _shop_obj = asset_get_index("obj_shopkeeper");
    if (_shop_obj == -1) _shop_obj = asset_get_index("obj_shop");

    if (_shop_obj == -1)
    {
        show_debug_message("[SPAWN][ERROR] spawn_shop: neither obj_shopkeeper nor obj_shop exists.");
        return;
    }

    instance_create_layer(room_width * 0.5, room_height * 0.5, "Instances", _shop_obj);
    show_debug_message("[SPAWN] spawn_shop created object index=" + string(_shop_obj));
}
