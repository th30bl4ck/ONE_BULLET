// Detect the moment it becomes unlocked (false -> true)
if (!_unlocked_prev && unlocked)
{
    _opening = true;
    image_index = 0;
    image_speed = 1; // play
}

// If currently opening, stop on last frame once finished
if (_opening)
{
    if (image_index >= image_number - 1)
    {
        image_index = image_number - 1; // stay on last frame
        image_speed = 0;
        _opening = false;
    }
}

_unlocked_prev = unlocked;