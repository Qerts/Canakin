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
	//center window
	var centerWindow:FlxSprite;
	//text window
	var textWindow:FlxSprite;
	var textBox:FlxText;
		
		
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
		//center window - obdelník obrazovečky
		centerWindow = new FlxSprite();
		centerWindow.makeGraphic(Std.int(FlxG.width * 0.4), Std.int(FlxG.height * 0.25), FlxColor.GRAY);
		centerWindow.setPosition(FlxG.width * 0.3, FlxG.height * 0.725);
		add(centerWindow);
		//text window - textové pole obrazovečky
		textWindow = new FlxSprite();
		textWindow.makeGraphic(Std.int(FlxG.width * 0.38), Std.int(FlxG.height * 0.22), FlxColor.BLACK);
		textWindow.setPosition(FlxG.width * 0.31, FlxG.height * 0.74);
		add(textWindow);
		textBox = new FlxText();
		textBox.makeGraphic(Std.int(FlxG.width * 0.38), Std.int(FlxG.height * 0.22));
		textBox.setPosition(FlxG.width * 0.31, FlxG.height * 0.74);
		textBox.size = 19;
		textBox.text = "HULL    |||||||||||||||||||| 100%" + "\nSHIELD |||||||||||||||||||| 100%" + "\nSHIELD REGEN RATE 5" + "\nWEAPON EFFICIENCY 15";
		add(textBox);
		
	}
	
	/**
	 * Metoda vracející vlastnost zvolenou pro boost.
	 * @return
	 */
	public function GetBoostStat():StatName { return chosenBoostStat; }
	/**
	 * Metoda nastaví text do textboxu. Přepíše defaultní hodnoty!
	 * @param	text
	 */
	public function SetText(text:String):Void 
	{
		textBox.text = text;
	}
	/**
	 * Tato metoda nastaví hodnoty do textboxu v dané formátu.
	 * @param	HP zdraví lodě v procentech
	 * @param	Shield stav štítu v procentech
	 * @param	RegenRate hodnota regenerace štítu
	 * @param	WeaponPower síla zbraně
	 */
	public function ChangeValues(HP:Int, Shield:Int, RegenRate:Int, WeaponPower:Int):Void 
	{
		//todo
		textBox.text = "HULL    |||||||||||||||||||| 100%" + "\nSHIELD |||||||||||||||||||| 100%" + "\nSHIELD REGEN RATE 5" + "\nWEAPON EFFICIENCY 15";

	}
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
	private function BoostShieldRecoveryButton():Void { chosenBoostStat = StatName.ShieldRecovery; }
	/**
	 * Metoda nastavující vlastnost pro boost na shield points.
	 */
	private function BoostShieldButton():Void { chosenBoostStat = StatName.ShieldPoints; }
	/**
	 * Metoda nastavující vlastnost pro boost na weapon power.
	 */
	private function BoostWeaponButton():Void { chosenBoostStat = StatName.WeaponPower; }
	
	
	
}