package;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import haxe.Timer;
import openfl.geom.Point;
import flixel.util.FlxRandom;
import flixel.util.FlxColor;

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
	var rangeCounter:Int;
	
	
	public function new(startX:Int, startY:Int, targetX:Int, targetY:Int, type:ProjectileType, bearingDmg:Int = 0, speed:Int = 10) 
	{
		super();
		
		projectile = new FlxSprite();
		projectile.makeGraphic(30, 10);
		projectile.setPosition(startX, startY);
		start = new Point(startX, startY);
		target = new Point(targetX, FlxRandom.intRanged( Std.int(targetY * 0.7), Std.int(targetY * 1.3)));
		this.rangeCounter = speed;
		
		ClaculateSpeed(speed);
		
		
		switch (type) 
		{
			case ProjectileType.Laser:
				//přiřadit skin
				projectile.color = FlxColor.RED;
			case ProjectileType.ShieldAimedMissile:
				//přiřadit skin
				projectile.color = FlxColor.YELLOW;
			case ProjectileType.WeaponAimedMissile:
				//přiřadit skin
				projectile.color = FlxColor.BLUE;
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
			projectile.y -= speed.y;
		}else 
		{
			projectile.y += speed.y;
		}
		
		
		if (rangeCounter <= 0) 
		{
			this.destroy();
		}else 
		{
			rangeCounter--;
		}
		
	}
	
}