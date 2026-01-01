function scr_coins_spawn(_count)
{
    if (_count <= 0) return;

    var margin_x = room_width * 0.25;
    var margin_y = room_height * 0.25;

    repeat (_count)
    {
        var xx = random_range(margin_x, room_width - margin_x);
        var yy = random_range(margin_y, room_height - margin_y);

        instance_create_layer(xx, yy, "Instances", obj_coin);
    }
}
