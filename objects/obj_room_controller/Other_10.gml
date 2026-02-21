function spawn_room_content()
{
    switch(room_data.type)
    {
        case "start":
            show_debug_message("Start Room");
        break;

        case "combat":
            spawn_wave(room_data.difficulty);
        break;

        case "elite":
            spawn_elite_wave(room_data.difficulty);
        break;

        case "shop":
            instance_create_layer(room_width / 2, room_height / 2, "Instances", obj_shopkeeper);
        break;

        case "boss":
            spawn_boss();
        break;
    }
}