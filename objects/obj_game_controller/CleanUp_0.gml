if (ds_exists(global.run_rooms, ds_type_list))
{
    ds_list_destroy(global.run_rooms);
}