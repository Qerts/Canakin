package;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.FlxG;
import flixel.text.FlxTextField;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;

class Player extends Ship
{
	private static var player:Player;
	
	var ship:FlxSpriteGroup;
	
	var cam:FlxCamera;
	var testText:FlxTextField;
	
	var hpBar:FlxBar;
	var shieldBar:FlxBar;
	
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
		
		hpBar = new FlxBar(FlxG.width * 0.05, FlxG.height * 0.65, FlxBar.FILL_LEFT_TO_RIGHT, Std.int(FlxG.width * 0.2), Std.int(FlxG.height * 0.05), null, "", 0, hitpoints, true);
		hpBar.createFilledBar(0xFF720000,FlxColor.RED,true);
		//hpBar. = FlxColor.RED;
		hpBar.currentValue = 0;
		add(hpBar);
		
		shieldBar = new FlxBar(FlxG.width * 0.05, FlxG.height * 0.55, FlxBar.FILL_LEFT_TO_RIGHT, Std.int(FlxG.width * 0.2), Std.int(FlxG.height * 0.05), null, "", 0, shield, true);
		add(shieldBar);
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
		hpBar.currentValue = currentHP;
		shieldBar.currentValue = currentShield;
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