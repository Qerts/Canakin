package;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
using flixel.FlxSprite;
using flixel.FlxG;

/**
 * ...
 * @author Qerts
 */
class UserInterface extends FlxSpriteGroup 
{

	//panel
	var mainPanel:FlxSprite;
	var leftWing:FlxSprite;
	var rightWing:FlxSprite;
	//attack button
	var attackButton:FlxSprite;
	//airforshield button
	var aimForShieldButton:FlxSprite;
	//aimforweapon button
	var aimForWeaponButton:FlxSprite;
	//evade button
	var evadeButton:FlxSprite;
	//boost button
	var boostButton:FlxSprite;
	//boostvalues tributton
	var boostShiledButton:FlxSprite;
	var boostShieldRecoveryButton:FlxSprite;
	var boostWeaponsButton:FlxSprite;
	//center area
	var hitpointsValue:FlxSprite;
	var hitpointsCover:FlxSprite;
	var energyValue:FlxSprite;
	var energyCover:FlxSprite;
	var shieldValue:FlxSprite;
	var shieldCover:FlxSprite;
		
		
	//working values
	var chosenBoostStat:StatName;
	var attackBtn:Bool = false;
	var evadeBtn:Bool = false;
	var aimWeaponBtn:Bool = false;
	var aimShield:Bool = false;
	var boostBtn:Bool = false;
	
	public function new() 
	{
		super();
		//panel - bude nahrazeno "vykousnutou texturou"
		mainPanel = new FlxSprite();
		mainPanel.makeGraphic(FlxG.width, Std.int(FlxG.height * 0.4));
		mainPanel.setPosition(0, FlxG.height * 0.6);
		add(mainPanel);
		//attack button - kulaté tlačítko pro útok
		attackButton = new FlxButton(0,0,"",AttackButton);
		attackButton.makeGraphic(Std.int(FlxG.height * 0.15), Std.int(FlxG.height * 0.15), FlxColor.RED);
		attackButton.setPosition(FlxG.width * 0.86, FlxG.height * 0.72);
		add(attackButton);
		//airforshield button - kulaté malé tlačítko pro míření na štít
		aimForShieldButton = new FlxButton(0,0,"",AimForShieldButton);
		aimForShieldButton.makeGraphic(Std.int(FlxG.height * 0.08), Std.int(FlxG.height * 0.08), FlxColor.RED);
		aimForShieldButton.setPosition(FlxG.width * 0.75, FlxG.height * 0.78);
		add(aimForShieldButton);
		//aimforweapon button - kulaté malé tlačítko pro míření na zbraně
		aimForWeaponButton = new FlxButton(0,0,"",AimForWeaponButton);
		aimForWeaponButton.makeGraphic(Std.int(FlxG.height * 0.08), Std.int(FlxG.height * 0.08), FlxColor.RED);
		aimForWeaponButton.setPosition(FlxG.width * 0.8, FlxG.height * 0.88);
		add(aimForWeaponButton);
		//evade button - obdelníkové tlačítko pro úhyb
		evadeButton = new FlxButton(0,0,"",EvadeButton);
		evadeButton.makeGraphic(Std.int(FlxG.width * 0.12), Std.int(FlxG.height * 0.1), FlxColor.AZURE);
		evadeButton.setPosition(FlxG.width * 0.05, FlxG.height * 0.7);
		add(evadeButton);
		//boost button - obdélníkové tlačítko pro boost
		boostButton = new FlxButton(0,0,"",BoostButton);
		boostButton.makeGraphic(Std.int(FlxG.width * 0.12), Std.int(FlxG.height * 0.1), FlxColor.FOREST_GREEN);
		boostButton.setPosition(FlxG.width * 0.05, FlxG.height * 0.86);
		add(boostButton);
		//boostvalues tributton - tři malá kulatá tlačítka pro volbu boost vlastnosti
		boostShieldRecoveryButton = new FlxButton(0,0,"",BoostShieldRecoveryButton);
		boostShieldRecoveryButton.makeGraphic(Std.int(FlxG.height * 0.08), Std.int(FlxG.height * 0.08), FlxColor.FOREST_GREEN);
		boostShieldRecoveryButton.setPosition(FlxG.width * 0.2, FlxG.height * 0.7);
		add(boostShieldRecoveryButton);
		boostShiledButton = new FlxButton(0,0,"",BoostShieldButton);
		boostShiledButton.makeGraphic(Std.int(FlxG.height * 0.08), Std.int(FlxG.height * 0.08), FlxColor.FOREST_GREEN);
		boostShiledButton.setPosition(FlxG.width * 0.2, FlxG.height * 0.79);
		add(boostShiledButton);
		boostWeaponsButton = new FlxButton(0,0,"",BoostWeaponButton);
		boostWeaponsButton.makeGraphic(Std.int(FlxG.height * 0.08), Std.int(FlxG.height * 0.08), FlxColor.FOREST_GREEN);
		boostWeaponsButton.setPosition(FlxG.width * 0.2, FlxG.height * 0.88);
		add(boostWeaponsButton);
		//center area - oblast statbarů
		//při otexturování bude dle textur třeba změnit pozice
		hitpointsValue = new FlxSprite();
		hitpointsValue.makeGraphic(Std.int(FlxG.width * 0.1), Std.int(FlxG.height * 0.1), FlxColor.GREEN);
		hitpointsValue.setPosition(FlxG.width * 0.35, FlxG.height * 0.8);
		add(hitpointsValue);
		hitpointsCover = new FlxSprite();
		hitpointsCover.makeGraphic(Std.int(FlxG.width * 0.1), Std.int(FlxG.height * 0.1), FlxColor.WHITE);
		hitpointsCover.setPosition(FlxG.width * 0.35, FlxG.height * 0.9);
		add(hitpointsCover);
		energyValue = new FlxSprite();
		energyValue.makeGraphic(Std.int(FlxG.width * 0.1), Std.int(FlxG.height * 0.1), FlxColor.YELLOW);
		energyValue.setPosition(FlxG.width * 0.45, FlxG.height * 0.8);
		add(energyValue);
		energyCover = new FlxSprite();
		energyCover.makeGraphic(Std.int(FlxG.width * 0.1), Std.int(FlxG.height * 0.1), FlxColor.WHITE);
		energyCover.setPosition(FlxG.width * 0.45, FlxG.height * 0.9);
		add(energyCover);
		shieldValue = new FlxSprite();
		shieldValue.makeGraphic(Std.int(FlxG.width * 0.1), Std.int(FlxG.height * 0.1), FlxColor.BLUE);
		shieldValue.setPosition(FlxG.width * 0.55, FlxG.height * 0.8);
		add(shieldValue);
		shieldCover = new FlxSprite();
		shieldCover.makeGraphic(Std.int(FlxG.width * 0.1), Std.int(FlxG.height * 0.1), FlxColor.WHITE);
		shieldCover.setPosition(FlxG.width * 0.55, FlxG.height * 0.9);
		add(shieldCover);
		
		//pozor!!! při nasazení textur barů je nutné řešit i setové metody
		SetHitpoints(50, 100);
		SetShield(33, 100);
		
		
		//pro nastavení počáteční hodnoty boostu
		BoostShieldButton();
	}
	public function SetHitpoints(value:Int, max:Int):Void 
	{
		//dostat procento vlastnosti
		var valuepercent = (value / (max / 100));
		//převést na procento vysunutí
		var coverratio = valuepercent * (hitpointsValue.height / 100);
		//vysunout
		hitpointsValue.y = FlxG.height * 0.9 - coverratio;
	}
	public function SetShield(value:Int, max:Int):Void 
	{
		//dostat procento vlastnosti
		var valuepercent = (value / (max / 100));
		//převést na procento vysunutí
		var coverratio = valuepercent * (shieldValue.height / 100);
		//vysunout
		shieldValue.y = FlxG.height * 0.9 - coverratio;
	}
	public function SetEnergy(value:Int, max:Int):Void
	{
		//dostat procento vlastnosti
		var valuepercent = (value / (max / 100));
		//převést na procento vysunutí
		var coverratio = valuepercent * (energyValue.height / 100);
		//vysunout
		energyValue.y = FlxG.height * 0.9 - coverratio;
	}
	
	
	/**
	 * Metoda vracející vlastnost zvolenou pro boost.
	 * @return
	 */
	public function GetBoostStat():StatName { return chosenBoostStat; }
	/**
	 * Tato metoda nastaví příznak tlačítka 
	 */
	private function AttackButton():Void { attackBtn = true; }
	/**
	 * Tato metoda nastaví příznak tlačítka 
	 */
	private function AimForShieldButton():Void { aimShield = true; }
	/**
	 * Tato metoda nastaví příznak tlačítka 
	 */
	private function AimForWeaponButton():Void { aimWeaponBtn = true; }
	/**
	 * Tato metoda nastaví příznak tlačítka 
	 */
	private function EvadeButton():Void { evadeBtn = true; }
	/**
	 * Tato metoda nastaví příznak tlačítka 
	 */
	private function BoostButton():Void { boostBtn = true; }
	/**
	 * Tlačítka: útok, evade, aimweapon, aimshield, boost.
	 * @return
	 */
	public function GetPushedButtons():Array<Bool> 
	{
		var returnValue = new Array<Bool>();
		returnValue.push(attackBtn);
		attackBtn = false;
		returnValue.push(evadeBtn);
		evadeBtn = false;
		returnValue.push(aimWeaponBtn);
		aimWeaponBtn = false;
		returnValue.push(aimShield);
		aimShield = false;
		returnValue.push(boostBtn);
		boostBtn = false;
		return returnValue;
	}
	/**
	 * Metoda nastavující vlastnost pro boost na shield recovery.
	 */
	private function BoostShieldRecoveryButton():Void 
	{ 
		chosenBoostStat = StatName.ShieldRecovery;
		boostShieldRecoveryButton.color = FlxColor.AQUAMARINE;
		boostWeaponsButton.color = FlxColor.FOREST_GREEN;
		boostShiledButton.color = FlxColor.FOREST_GREEN;
	}
	/**
	 * Metoda nastavující vlastnost pro boost na shield points.
	 */
	private function BoostShieldButton():Void 
	{ 
		chosenBoostStat = StatName.ShieldPoints; 
		boostShieldRecoveryButton.color = FlxColor.FOREST_GREEN;
		boostWeaponsButton.color = FlxColor.FOREST_GREEN;
		boostShiledButton.color = FlxColor.AQUAMARINE;
	}
	/**
	 * Metoda nastavující vlastnost pro boost na weapon power.
	 */
	private function BoostWeaponButton():Void 
	{ 
		chosenBoostStat = StatName.WeaponPower;
		boostShieldRecoveryButton.color = FlxColor.FOREST_GREEN;
		boostWeaponsButton.color = FlxColor.AQUAMARINE;
		boostShiledButton.color = FlxColor.FOREST_GREEN;
	}
	
	
	
}