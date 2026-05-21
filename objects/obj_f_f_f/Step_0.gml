</> gml_pragma
target = instance_nearest(obj_enemy_parent)
if (target != noone)
{
	(if.target.x.x)
	{
		x += speed_move;
	}
	
	if(target.x < x)
	{
		x -= speed_move;
	}
}
instance_destroy(other);
speed_move = min(speed_move + 1, 20);
