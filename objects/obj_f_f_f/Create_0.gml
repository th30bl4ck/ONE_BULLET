normal_speed = 4;
move_speed = normal_speed;

follow_speed = 0.08;

mode = "follow";

dir_x = 0;
dir_y = 0;

min_speed = 0.5;

function start_attack()
{
    mode = "attack";
    move_speed = normal_speed;

    switch(irandom(3))
    {
        case 0:
            dir_x = 1;
            dir_y = -1;
        break;

        case 1:
            dir_x = -1;
            dir_y = -1;
        break;

        case 2:
            dir_x = 1;
            dir_y = 1;
        break;

        case 3:
            dir_x = -1;
            dir_y = 1;
        break;
    }
}