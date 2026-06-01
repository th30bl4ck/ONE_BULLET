switch(button_action)
{
    case "play":
        room_goto(rm_game);
    break;

    case "settings":
        room_goto(rm_settings);
    break;

    case "quit":
        game_end();
    break;
}