switch(button_action)
{
    case "play":
        room_goto(starting_room);
    break;

    case "settings":
        room_goto(settings_room);
    break;

    case "quit":
        game_end();
    break;
}
