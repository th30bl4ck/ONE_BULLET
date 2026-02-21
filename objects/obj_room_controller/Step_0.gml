// If no enemies remain
if (instance_number(obj_enemy_parent) <= 0)
{
    if (!room_cleared)
    {
        room_cleared = true;
        show_debug_message("Room Cleared");
    }
}