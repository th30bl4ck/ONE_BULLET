target = instance_nearest(x,y,obj_enemy_parent);
if (target != noone)
{
	if (target.x.x)
	{
		x += speed_move;
	}
	
	if (target.x < x)
	{
		x -= speed_move;
	}
}
instance_destroy(obj_enemy_parent);
speed_move = min(speed_move + 1, 20);
