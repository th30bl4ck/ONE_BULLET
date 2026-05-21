if (!_unlocked_prev && unlocked)
{
    _opening = true;
    image_index = 0;
    image_speed = 1;
}

if (_opening)
{
    if (image_index >= image_number - 1)
    {
        image_index = image_number - 1;
        image_speed = 0;
        _opening = false;
    }
}

_unlocked_prev = unlocked;