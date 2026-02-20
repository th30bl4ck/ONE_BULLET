function scr_csv_to_grid(_csv)
{
    _csv = string_replace_all(_csv, "\r", "");
    var lines = string_split(_csv, "\n");

    var grid = array_create(array_length(lines));

    for (var row = 0; row < array_length(lines); row++)
    {
        var line = lines[row];
        var cols = string_split(line, ",");
        grid[row] = array_create(array_length(cols));

        for (var col = 0; col < array_length(cols); col++)
        {
            grid[row][col] = real(cols[col]);
        }
    }

    return grid;
}