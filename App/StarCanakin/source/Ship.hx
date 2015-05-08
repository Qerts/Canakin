package;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxBar;
import flixel.util.FlxPoint;
using flixel.util.FlxRandom;
import flixel.FlxG;
import flixel.util.FlxColor;

/**
 * ...
 * @author Qerts
 */
class Ship extends FlxSpriteGroup
{
	
	public var status:Status;
	public var isAlive:Bool;
	
	var decision:Decision;
	
	//deklarace statů
	var hitpoints:Int;
	var shield:Int;
	var shieldRecovery:Int;
	var weaponPower:Int;
	var energyLevel:Int;
	var luck:Int;
	
	//dočasné bonusy pro dané kolo
	var shieldTmp:Int;
	var shieldRecoveryTmp:Int;
	var weaponPowerTmp:Int;
	
	//aktuální hodnoty
	var currentHP:Int;
	var currentShield:Int;
	var currentEnergy:Int;
	
	public var level:Int;
	
	//Cooldowny
	public var CooldownForEvade:Int;
	public var CooldownForAimForWeapons:Int;
	public var CooldownForAimForShields:Int;
	public var CooldownForWeapons:Int;
	public var CooldownFowShields:Int;
	
	
	
	
	//vibrační hodnoty
	private var vibrate:Bool = false;
	private var vibrationCounter = 0;
	
	//prvky GUI
	//var hpBar:FlxBar;
	//var shieldBar:FlxBar;
	var shieldSprite:FlxSprite;
	
	
	public function new() 
	{
		super();
		CooldownForEvade = 0;
		CooldownForAimForShields = 0;
		CooldownForAimForWeapons = 0;
		CooldownForWeapons = 0;
		CooldownFowShields = 0;
		
		decision = Decision.NOTDECIDED;
		
		initStats();
	}
	
	override public function update():Void 
	{
		super.update();
		//hpBar.currentValue = currentHP;
		//shieldBar.currentValue = currentShield;
		
		//update shield opacity
		var opacity:Float = (currentShield / (shield / 100)) / 100;
		shieldSprite.alpha = opacity;
		
		
		//vibrations
		if (vibrate) 
		{
			if (vibrationCounter == 0) 
			{
				vibrationCounter = 15;
			}
			
			switch (vibrationCounter%5) 
			{
				case 1:
					this.x += 2;
					this.y += 2;
				case 2:
					this.y -= 4;
				case 3:
					this.x -= 4;
				case 4:
					this.y += 2;
				case 0:
					this.x += 2;
				default:
					
			}
			
			vibrationCounter--;
			
			if (vibrationCounter == 0) 
			{
				vibrate = false;
			}
			
			
		}
	}
	
	/**
	 * vytvori vlastnosti lode
	 * @param level vytvorene lode
	 */
	private function initStats(level:Int = 10) 
	{
		hitpoints = FlxRandom.intRanged(6 + level, 9 + level);
		
		if (hitpoints <= (9 + level)-2)
		{
			energyLevel = 2;
		}else 
		{
			energyLevel = 1;
		}
		
		luck = 5;
		for (a in 0...level)
		{
			var randLuck = FlxRandom.intRanged(2, 3);
			luck += randLuck;
		}
		
		var totalPoints = 10 + level;
		
		weaponPower = FlxRandom.intRanged(3 + level, 5 + level);
		totalPoints -= weaponPower;
		
		shield = 2;
		shieldRecovery = 2;
		
		totalPoints -= shield + shieldRecovery;
		
		while (totalPoints != 0)
		{
			var rand = FlxRandom.intRanged(0, 100);
			if (rand < 50)
			{
				shield++;
				totalPoints--;
			}else
			{
				shieldRecovery++;
				totalPoints--;
			}
		}
		
		if (level == 1)
		{
			shield = Std.int(shield * 2);
		}else
		{
			shield = Std.int(shield * level);
		}
		
		currentEnergy = energyLevel;
		currentHP = hitpoints;
		currentShield = shield;
		
		shieldTmp = 0;
		shieldRecoveryTmp = 0;
		weaponPowerTmp = 0;
		
		isAlive = true;
		
		this.level = level;
		
	}
	
	///
	//Tato metoda vrací typ akce, který loď má provést.
	///
	public function GetDecision():Decision
	{
		return decision;
	}
		
	/**
	 * Tato metoda vypočte a vrátí hodnotu útoku.
	 * @param	critEnabled Pokud je zadáno true, může nastat critical hit. Pokud je zadáno false nebo nic, crit nenastane.
	 * @return
	 */
	public function Attack(critEnabled:Bool = false):Int
	{		
		var min:Int = weaponPower -1;
		var max:Int = weaponPower +1;
		if (critEnabled) 
		{
			//jestli projde critical hit (nastaveno na luck)
			if (FlxRandom.intRanged(0, 100) <= luck) 
			{
				max = weaponPower + level;
				//min = weaponPower + level;
				return FlxRandom.intRanged(min, max);
			}		
			return FlxRandom.intRanged(min, max);
		}else 
		{
			return FlxRandom.intRanged(min, max);
		}
	}
	
	/**
	 * Tato metoda vypočte a vrátí hodnotu uhnutí.
	 * @return vrací float číslo 0-1, které určuje poměr uhnutí
	 */
	public function Evade():Float
	{
		CooldownForEvade = 1;
		if ((FlxRandom.intRanged(1,100) + luck) > 75) 
		{
			return 0.0;
		}else 
		{
			return 0.5;
		}		
	}
	/**
	 * Tato metoda je pro útok zamířený na zbraně. Vrací pole, kde na první pozici je dmg a na druhé pozici je hodnota - 0 znamená, že útok nevyšel, 1 znamená, že útok vyšel.
	 * @return vrací pole, kde na první pozici je dmg a na druhé pozici je hodnota - 0 znamená, že útok nevyšel, 1 znamená, že útok vyšel
	 */
	public function AimForWeapons():Array<Int>
	{		
		CooldownForAimForWeapons += 3;
		
		var min:Int = weaponPower -3;
		var max:Int = weaponPower -1;
		var returnArray = new Array<Int>();
		returnArray[0] = FlxRandom.intRanged(min, max);
		
		if (FlxRandom.intRanged(luck,100) >= 50) 
		{
			returnArray[1] = 1;
			return returnArray; 
		}else 
		{
			returnArray[1] = 0;
			return returnArray; 
		}	
	}
	/**
	 * Tato metoda přejímá hodnoty metody AimForWeapons oponenta.
	 * @param	twinValue
	 */
	public function AimedForWeapons(twinValue:Array<Int>)
	{
		trace(twinValue[0], twinValue[1]);
		var evadation:Float = 1;
		if (decision == Decision.EVADE) 
		{
			evadation = Evade();
		}
		DoDamage(Math.round((twinValue[0] * evadation)));
		if (twinValue[1] == 1) 
		{
			CooldownForWeapons++;
		}
	}
	
	/**
	 * Tato metoda je pro útok zamířený na štíty. Vrací pole, kde na první pozici je dmg a na druhé pozici je hodnota - 0 znamená, že útok nevyšel, 1 znamená, že útok vyšel.
	 * @return vrací pole, kde na první pozici je dmg a na druhé pozici je hodnota - 0 znamená, že útok nevyšel, 1 znamená, že útok vyšel
	 */
	public function AimForShields():Array<Int>
	{		
		CooldownForAimForShields += 3;
		
		var min:Int = weaponPower -3;
		var max:Int = weaponPower -1;
		var returnArray = new Array<Int>();
		returnArray[0] = FlxRandom.intRanged(min, max);
		
		if (FlxRandom.intRanged(luck,100) >= 50) 
		{
			returnArray[1] = 1;
			return returnArray; 
		}else 
		{
			returnArray[1] = 0;
			return returnArray; 
		}	
	}
	/**
	 * Tato metoda přejímá hodnoty metody AimForWeapons oponenta.
	 * @param	twinValue
	 */
	public function AimedForShields(twinValue:Array<Int>)
	{
		trace(twinValue[0], twinValue[1]);
		var evadation:Float = 1;
		if (decision == Decision.EVADE) 
		{
			evadation = Evade();
		}
		DoDamage(Math.round((twinValue[0] * evadation)));
		if (twinValue[1] == 1) 
		{
			CooldownFowShields+=2;
		}
	}
	
	///
	//Tato metoda vrací hodnotu štítu pro použití ve vyhodnocení střetu.
	///
	public function GetShield():Int 
	{
		return currentShield;
	}
	
	/**
	 * ziskani aktualniho poctu hp
	 * @return aktualni pocet hp
	 */
	public function GetHull():Int 
	{
		return currentHP;
	}
	
	/**
	 * metoda pro obnoveni stitu. Vola se na konci kola
	 */
	public function RechargeShield()
	{
		if (CooldownFowShields == 0) 
		{
			var tmpRechargeRate:Float = shieldRecovery / 15;
			var tmp:Float = ((shield - currentShield) * tmpRechargeRate);
			currentShield = Math.round(currentShield + ((shield - currentShield) * tmpRechargeRate));
		}
	}
	

	
	
	/**
	 * Tato metoda slouží k poškození lodi. Poškodí štít a pokud jej zničí a projde skrze, poškodí loď.
	 * @param	dmg intagerová hodnota čistého dmg, která bude rovnou počítána se štítem a HP dané lodi
	 */
	public function DoDamage(dmg:Int)
	{ 
		var sumHeatlth:Int = currentHP + currentShield - dmg;
		trace("DoDamage method: Damage recieved " + dmg + " current HP " + currentHP + " current shield " + currentShield);
		if (dmg >= currentShield) 
		{
			currentHP = currentHP + currentShield - dmg;
			currentShield = 0;
			if (currentHP <= 0) 
			{
				isAlive = false;
			}
		}
		if (dmg < currentShield) 
		{
			currentShield -= dmg;
		}
		trace("DoDamage method: Damage recieved " + dmg + " current HP after action " + currentHP + " current shield after action " + currentShield);
		var dmglbl = new DamageIndicator(20, 0, dmg, true, 1000);
		add(dmglbl);
		
		//set vibration
		if (dmg > 0) 
		{
			vibrate = true;
		}	
	}	
	
	
	/**
	 * Tato metoda by měla být použita pro boostnutí vlastností nebo zvýšení vlastností při levelování.
	 * @param	statName vlastnost, která bude navýšena
	 * @param	temporary zda je vlastnost dočasná nebo trvalá, nebo-li zda se jedná o boost nebo level
	 */
	public function Boost(statName:StatName, temporary:Bool)
	{
		if (currentEnergy < 1) 
		{
			return;
		}
		if (temporary) 
		{
			//dočasné přidělení bodů, zároveň odečte energii pro boostnutí
			switch (statName) 
			{
				case StatName.EnergyLevel:
				case StatName.HealthPoints:
				case StatName.Luck:
				case StatName.ShieldPoints:
					//boostnutí štítů přidá hodnotu levelu
					shieldTmp = shield + level;
					shield += level;
					currentEnergy--;
				case StatName.ShieldRecovery:
					shieldRecoveryTmp++;
					shieldRecovery++;
					currentEnergy--;
				case StatName.WeaponPower:
					weaponPowerTmp++;	
					weaponPower++;
					currentEnergy--;
			}
		}else 
		{
			//trvalé přidělení bodů
			switch (statName) 
			{
				case StatName.EnergyLevel:
					energyLevel++;
				case StatName.HealthPoints:
					hitpoints++;
				case StatName.Luck:
					luck++;
				case StatName.ShieldPoints:
					shield++;
				case StatName.ShieldRecovery:
					shieldRecovery++;
				case StatName.WeaponPower:
					weaponPower++;					
			}
		}
	}
	
	public function DecreaseCooldowns()
	{
		if (CooldownForEvade > 0) 
		{
			CooldownForEvade--;
		}
		if (CooldownForAimForShields > 0) 
		{
			CooldownForAimForShields--;
		}
		if (CooldownForAimForWeapons >0) 
		{
			CooldownForAimForWeapons--;
		}
		if (CooldownForWeapons > 0) 
		{
			CooldownForWeapons--;
		}
		if (CooldownFowShields > 0) 
		{
			CooldownFowShields--;
		}
	}
	
	public function SetDecision(dec:Decision)
	{
		this.decision = dec;
		status = Status.WAITING;
	}
	
	/**
	 * Tato metoda vytváří elementy GUI, které zobrazují HP a Shield lodi.
	 * @param	player
	 */
	private function createBars(player:Bool):Void
	{
		
		if(player){
			shieldSprite = new FlxSprite(this.x, this.y);
			shieldSprite.loadGraphic("assets/images/shield.png");
			shieldSprite.scale = new FlxPoint(1, 2);
			shieldSprite.setPosition(this.x - this.width * 0.5, this.y - this.height * 1.2);
			add(shieldSprite);
		}else 
		{
			shieldSprite = new FlxSprite(this.x, this.y);
			shieldSprite.loadGraphic("assets/images/shield.png");
			shieldSprite.scale = new FlxPoint(1,2);
			shieldSprite.setPosition(this.x - this.width * 5, this.y - this.height * 1.2);
			add(shieldSprite);
		}
		
		
		/*
		if (player)
		{
			hpBar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, Std.int(FlxG.width * 0.2), Std.int(FlxG.height * 0.05), null, "", 0, hitpoints, true);
			hpBar.createFilledBar(0xFF720000,FlxColor.RED,true);
			add(hpBar);
			
			shieldBar = new FlxBar(FlxG.width * 0.1, FlxG.height * 0.15, FlxBar.FILL_LEFT_TO_RIGHT, Std.int(FlxG.width * 0.2), Std.int(FlxG.height * 0.05), null, "", 0, shield, true);
			add(shieldBar);
		}else
		{
			hpBar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, Std.int(FlxG.width * 0.2), Std.int(FlxG.height * 0.05), null, "", 0, hitpoints, true);
			hpBar.setPosition(FlxG.width * 0.5 - hpBar.width, FlxG.height * 0.65);
			hpBar.createFilledBar(0xFF720000,FlxColor.RED,true);
			add(hpBar);
			
			shieldBar = new FlxBar(0,0, FlxBar.FILL_LEFT_TO_RIGHT, Std.int(FlxG.width * 0.2), Std.int(FlxG.height * 0.05), null, "", 0, shield, true);
			shieldBar.setPosition(FlxG.width * 0.95 - hpBar.width, FlxG.height * 0.55);
			add(shieldBar);
		}*/
		
	}
	
	public function GetEnergyValue():Int { return currentEnergy; }
}