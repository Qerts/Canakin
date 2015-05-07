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
import flixel.text.FlxTextField;


/**
 * ...
 * @author Qerts
 */
class Enemy extends Ship
{
    var random:Int;
	var ship:FlxSpriteGroup;
	
	var testText:FlxTextField;
	
	var lastRoundDmg:Int = 0;
	
	public function new() 
	{
		super();
		random = FlxRandom.intRanged(1, 4);	
		ship = new FlxSpriteGroup();
		ship.add(ShipGenerator.getShip());
		add(ship);
		
		ship.setPosition(FlxG.width * 0.95-ship.width,FlxG.height*0.15);
		ship.angle = 180;
		
		status = Status.STARTING;
		
		initStats();
		
		//testovací textfield
		testText = new FlxTextField(540, 0, 100, "Player \nWeapon: " + weaponPower + "\nHP: " + currentHP + "/" + hitpoints + "\nShield: " + currentShield + "/" + shield + "\nShield recovery: " + shieldRecovery + "\nEnergy: " + currentEnergy +"/" + energyLevel);
		add(testText);
		createBars(false);
	}
	
	override function update():Void
	{
		super.update();
		//vyplnění testovacího boxu
		testText.text = "Enemy \nWeapon: " + weaponPower + "\nHP: " + currentHP + "/" + hitpoints + "\nShield: " + currentShield + "/" + shield + "\nShield recovery: " + shieldRecovery + "\nEnergy: " + currentEnergy +"/" + energyLevel + "\nLevel: " + level;
		
		//pokud je starting, tak se přepne na deciding
		decide();
		
		status = Status.DECIDING;
		
		//pokud deciding, tak se rozhodne a přepne se na waiting
		if (status == Status.DECIDING) 
		{
			if (decision != Decision.NOTDECIDED) 
			{
				status = Status.WAITING;
			}	
		}
		//zbytek ve waitingu se řeší v boardu		
	}
	
	private function decide():Void
	{
		//randomDecide();
		dumbDecide();
		//smartDecide();
		//genuineDecide();
	}
	
	/**
	 * Náhodně volené volby nepřítelské lodi.
	 */
	private function randomDecide() 
	{
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
						if (currentEnergy > 0) 
						{
							decision = Decision.BOOSTWP;
						}else
						{
							decide();
						}
					case 3:
						if (currentEnergy > 0) 
						{
							decision = Decision.BOOSTSHIELD;
						}else
						{
							decide();
						}
					case 4:
						if (currentEnergy > 0) 
						{
							decision = Decision.BOOSTSHIELDRECOVERY;
						}else
						{
							decide();
						}
					case 5:						
						if (CooldownForEvade > 0) 
						{
							decide();
						}else 
						{
							decision = Decision.EVADE;	
						}
				}
			}
		}
	}
	
	/**
	 * Rozhodování probíhá pseudonáhodně. Snaží se spíše útočit, než uhýbat.
	 */
	private function dumbDecide() 
	{
		if (status == Status.STARTING) 
		{
			if (decision == Decision.NOTDECIDED) 
			{
				var top:Int = FlxRandom.intRanged(5,6);
				switch (FlxRandom.intRanged(1, top)) 
				{
					case 1:
						decision = Decision.ATTACK;
					case 2:
						decision = Decision.EVADE;		
					case 3:
						if (currentEnergy > 0) 
						{
							decision = Decision.BOOSTSHIELD;
						}else
						{
							decide();
						}
					case 4:
						if (currentEnergy > 0) 
						{
							decision = Decision.BOOSTSHIELDRECOVERY;
						}else
						{
							decide();
						}
					case 5:
						if (currentEnergy > 0) 
						{
							decision = Decision.BOOSTWP;
						}else
						{
							decide();
						}
					case 6:
						if (CooldownForAimForWeapons == 0) 
						{
							decision = Decision.AIMWEAPONS;
							trace("enemy decided aim");
						}else 
						{
							decide();
						}
				}
			}
		}
	}
	/**
	 * Rozhodování má určitou strategii, založenou na počátečních statech hráče.
	 */
	private function smartDecide() 
	{
		
	}
	
	/**
	 * Rozhodování je založeno na aktuálních statech hráče.
	 */
	private function genuineDecide()
	{
		
		
		if (status == Status.STARTING) 
		{
			var averageReceivedDamage:Float = 0;
			
			if (decision == Decision.NOTDECIDED) 
			{
				
			}
		}
	}

	
}
	