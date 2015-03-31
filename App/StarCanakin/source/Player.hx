package;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.FlxG;

class Player extends Ship
{
	private static var player:Player;
	
	var ship:FlxSpriteGroup;
	
	var cam:FlxCamera;
	
	public function new() 
	{
		super();
		
		ship = new FlxSpriteGroup();
		//ship.add(new FlxSprite("assets/images/starship_pattern.png"));
		ship.add(ShipGenerator.getShip());
		add(ship);
		
		ship.setPosition(FlxG.width * 0.05, FlxG.height * 0.15);
		status = Status.WAITING;
		
		
	}
	
	public static inline function getPlayer():Player
	{
		if (player == null)
			return player = new Player();
		else
			return player;
	}
	
	
	override function update():Void
	{
		
		if (FlxG.mouse.justPressed)
		{
			FlxG.camera.flash(0.5);
			FlxG.camera.shake(0.005);
		}
		//pokud je starting, tak se přepne na deciding
		if (status == Status.STARTING) 
		{
			//todo
			status = Status.DECIDING;
		}
		//pokud deciding, tak čeká na vstup od hráče a po přijetí se přepne an waiting
		if (status == Status.DECIDING) 
		{
			status = Status.WAITING;
		}
		//zbytek ve waitingu se řeší v boardu
	}
	
	
	
}