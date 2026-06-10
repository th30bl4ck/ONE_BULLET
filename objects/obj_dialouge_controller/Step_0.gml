if (active && array_length(dialogue_lines) > 0)
{
    var full_text = dialogue_lines[line_index];

    text_pos += text_speed;

    if (text_pos > string_length(full_text))
    {
        text_pos = string_length(full_text);
    }

    if (keyboard_check_pressed(vk_space))
    {
        if (text_pos < string_length(full_text))
        {
            text_pos = string_length(full_text);
        }
        else
        {
            line_index++;
            text_pos = 0;

            if (line_index >= array_length(dialogue_lines))
            {
                active = false;
                line_index = 0;
            }
        }
    }
}