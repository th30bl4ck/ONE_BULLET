function scr_paint_tilemap(_tilemap, _grid, _tw, _th)
{
    var h = array_length(_grid);
    var w = array_length(_grid[0]);

    for (var row = 0; row < h; row++)
    {
        for (var col = 0; col < w; col++)
        {
            var t = _grid[row][col];

            if (t >= 0)
            {
                tilemap_set_at_pixel(
                    _tilemap,
                    col * _tw,
                    row * _th,
                    t
                );
            }
        }
    }
}