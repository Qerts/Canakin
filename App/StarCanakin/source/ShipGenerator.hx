package ;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxRandom;

/**
 * ...
 * @author w
 */
class ShipGenerator
{
	
	public static function getShip():FlxSpriteGroup
	{
		var ship = new FlxSpriteGroup();
		
		var bodyPart = FlxRandom.intRanged(0, 2);
		var wingPart = FlxRandom.intRanged(0,2);
		
		
		switch(wingPart)
		{
			case 0:
				ship.add(new FlxSprite("assets/images/wings1.png"));
			case 1:
				ship.add(new FlxSprite("assets/images/wings2.png"));
			case 2:
				ship.add(new FlxSprite("assets/images/wings3.png"));
		}
		
		switch(bodyPart)
		{
			case 0:
				ship.add(new FlxSprite("assets/images/body1.png"));
			case 1:
				ship.add(new FlxSprite("assets/images/body2.png"));
			case 2:
				ship.add(new FlxSprite("assets/images/body3.png"));
		}
		
		
		
		//ship.add(new FlxSprite("assets/images/starship_pattern.png"));
		return ship;
	}
	
}