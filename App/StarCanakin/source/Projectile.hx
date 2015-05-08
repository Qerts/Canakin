package;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import openfl.geom.Point;

/**
 * ...
 * @author Qerts
 */
class Projectile extends FlxSpriteGroup
{

	var projectile:FlxSprite;
	var start:Point;
	var target:Point;
	var speed:Point;
	
	
	public function new(startX:Int, startY:Int, targetX:Int, targetY:Int, type:ProjectileType, bearingDmg:Int = 0, speed:Int = 10) 
	{
		super();
		
		projectile = new FlxSprite();
		projectile.makeGraphic(30, 10);
		projectile.setPosition(startX, startY);
		start = new Point(startX, startY);
		target = new Point(targetX, targetY);
		
		ClaculateSpeed(speed);
		
		
		switch (type) 
		{
			case ProjectileType.Laser:
				//přiřadit skin
			case ProjectileType.ShieldAimedMissile:
				//přiřadit skin
			case ProjectileType.WeaponAimedMissile:
				//přiřadit skin
			default:				
		}
		
		add(projectile);
	}

	private function ClaculateSpeed(speedRatio:Int)
	{
		var xrange:Float;
		var yrange:Float;
		if (start.x > target.x) 
		{
			xrange = start.x - target.x;
		}else 
		{
			xrange = target.x - start.x;
		}
		
		if (start.y > target.y) 
		{
			yrange = start.y - target.y;
		}else 
		{
			yrange = target.y - start.y;
		}
		
		speed = new Point(xrange / speedRatio, yrange / speedRatio);
		trace("HEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEELLLLOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO", xrange, yrange, speed);
	}
	
	override public function update():Void 
	{
		super.update();
		
		
		
		if (start.x > target.x) 
		{
			projectile.x -= speed.x;
		}else 
		{
			projectile.x += speed.x;
		}
		
		if (start.y > target.y) 
		{
			projectile.y += speed.y;
		}else 
		{
			projectile.y -= speed.y;
		}
		
		if (this.x == target.x) 
		{
			this.destroy();
		}
	}
	
}