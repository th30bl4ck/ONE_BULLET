if (!pressed)
{
    pressed = true;
    press_timer = press_wait;

    sprite_index = spr_pressed;
    image_index = 0;
    image_speed = 1;
}