// pressed animation playing
if (pressed)
{
    press_timer -= 1;

    if (press_timer <= 0)
    {
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
    }

    exit;
}

// hover detection
hovered = point_in_rectangle(
    mouse_x,
    mouse_y,
    bbox_left,
    bbox_top,
    bbox_right,
    bbox_bottom
);

// determine state
var new_state = "idle";

if (hovered)
{
    new_state = "hover";
}

// update sprite only if state changed
if (state != new_state)
{
    state = new_state;

    switch(state)
    {
        case "idle":
            sprite_index = spr_idle;
        break;

        case "hover":
            sprite_index = spr_hover;
            image_index = 0;
        break;
    }
}