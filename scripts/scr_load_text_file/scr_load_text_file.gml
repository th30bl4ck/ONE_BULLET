function scr_load_text_file(_path)
{
    var f = file_text_open_read(_path);
    if (f < 0) return "";
    var s = "";
    while (!file_text_eof(f))
    {
        s += file_text_read_string(f);
        file_text_readln(f);
        if (!file_text_eof(f)) s += "\n";
    }
    file_text_close(f);
    return s;
}