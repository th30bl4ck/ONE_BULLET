var progress = 1 - (life / max_life);
var fade = life / max_life;

draw_set_alpha(fade);

// white/yellow flash at the start
if (progress < 0.2)
{
    draw_set_color(c_white);
    draw_rectangle(x - 10, y - 10, x + 10, y + 10, false);

    draw_set_color(c_yellow);
    draw_rectangle(x - 18, y - 4, x + 18, y + 4, false);
    draw_rectangle(x - 4, y - 18, x + 4, y + 18, false);
}

// jagged explosion chunks
for (var i = 0; i < 14; i++)
{
    var dir = i * 26 + 10;
    var dist = radius * progress * random_range(0.45, 1);
    var size = 10 * fade + 3;

    var px = x + lengthdir_x(dist, dir);
    var py = y + lengthdir_y(dist, dir);

    if (i mod 3 == 0)
    {
        draw_set_color(c_yellow);
    }
    else if (i mod 3 == 1)
    {
        draw_set_color(c_orange);
    }
    else
    {
        draw_set_color(c_red);
    }

    draw_rectangle(
        px - size,
        py - size,
        px + size,
        py + size,
        false
    );
}

// smoke chunks near the end
if (progress > 0.45)
{
    draw_set_color(c_gray);

    for (var j = 0; j < 8; j++)
    {
        var dir2 = j * 45 + 20;
        var dist2 = radius * progress * random_range(0.3, 0.8);
        var size2 = 8 * fade + 4;

        var sx = x + lengthdir_x(dist2, dir2);
        var sy = y + lengthdir_y(dist2, dir2);

        draw_rectangle(
            sx - size2,
            sy - size2,
            sx + size2,
            sy + size2,
            false
        );
    }
}

draw_set_alpha(1);