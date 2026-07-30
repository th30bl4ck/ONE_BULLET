x += xspd;
y += yspd;

life--;

if(life <= 0)
{
    instance_destroy();
}