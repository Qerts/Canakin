package;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxPoint;
using flixel.util.FlxRandom;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.util.FlxVelocity;
import flixel.util.FlxCollision;
import flixel.FlxObject;

/**
 * ...
 * @author Qerts
 */
class Enemy extends Ship
{
    var random:Int;
	var ship:FlxSpriteGroup;
	//var defaultShellPosition:FlxPoint;
	
	
	
	
	
	public function new() 
	{
		super();
		random = FlxRandom.intRanged(1, 4);
		
		//defaultShellPosition = new FlxPoint(100, 100);
		
		ship = new FlxSpriteGroup();
		//ship.add(new FlxSprite("assets/images/starship_pattern.png"));
		ship.add(ShipGenerator.getShip());
		add(ship);
		
		ship.setPosition(FlxG.width * 0.95-ship.width,FlxG.height*0.15);
		ship.angle = 180;
		
		status = Status.WAITING;
		
		initStats(10);
		trace(hitpoints,energyLevel,luck,weaponPower,shield,shieldRecovery);
	}
	
	override function update():Void
	{
		//pokud je starting, tak se přepne na deciding
		if (status == Status.STARTING) 
		{
			//pro účely testování je nastaveno na random
			if (decision == Decision.NOTDECIDED) 
			{
				switch (FlxRandom.intRanged(1,5)) 
				{
					case 1:
						decision = Decision.ATTACK;
					case 2:
						decision = Decision.BOOSTHP;
					case 3:
						decision = Decision.BOOSTSHIELD;
					case 4:
						decision = Decision.BOOSTSHIELDRECOVERY;
					case 5:
						decision = Decision.EVADE;
						
						
					default:
						
				}
			}
			status = Status.DECIDING;
		}
		//pokud deciding, tak se rozhodne a přepne se na waiting
		if (status == Status.DECIDING) 
		{
			status = Status.WAITING;
		}
		//zbytek ve waitingu se řeší v boardu
		
		
		
		/*
		 * 
		 * testovaci pohyb
		if (FlxG.mouse.justReleased && shell.alive)
		{
			shell.kill();
		}else if (FlxG.mouse.justReleased && !shell.alive)
		{
			shell.reset(defaultShellPosition.x,defaultShellPosition.y);
		}
		
		if (FlxG.pixelPerfectOverlap(shell,enemy))
		{
			shell.kill();
		}
		
		shell.x += 5;
		
		*/
		
		
	}
	
	
}