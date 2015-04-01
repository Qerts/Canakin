package;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.FlxG;
import flixel.text.FlxTextField;

class Player extends Ship
{
	private static var player:Player;
	
	var ship:FlxSpriteGroup;
	
	var cam:FlxCamera;
	var testText:FlxTextField;
	
	public function new() 
	{
		super();
		
		ship = new FlxSpriteGroup();
		ship.add(ShipGenerator.getShip());
		add(ship);
		
		ship.setPosition(FlxG.width * 0.05, FlxG.height * 0.15);
		status = Status.STARTING;
		
		//testovací textfield
		testText = new FlxTextField(0, 0, 100, "Player \nWeapon: " + weaponPower + "\nHP: " + currentHP + "/" + hitpoints + "\nShield: " + currentShield + "/" + shield + "\nShield recovery: " + shieldRecovery + "\nEnergy: " + currentEnergy +"/" + energyLevel);
		add(testText);
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
		//vyplnění testovacího boxu
		testText.text = "Player \nWeapon: " + weaponPower + "\nHP: " + currentHP + "/" + hitpoints + "\nShield: " + currentShield + "/" + shield + "\nShield recovery: " + shieldRecovery + "\nEnergy: " + currentEnergy +"/" + energyLevel;

		//pokud je starting, tak se přepne na deciding
		if (status == Status.STARTING) 
		{
			//todo
			status = Status.DECIDING;
		}
		//pokud deciding, tak čeká na vstup od hráče a po přijetí se přepne an waiting
		if (status == Status.DECIDING) 
		{
			if (decision != Decision.NOTDECIDED) 
			{
				status = Status.WAITING;
			}			
		}
		//zbytek ve waitingu se řeší v boardu
	}
	
	
	
}