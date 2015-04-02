package;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxBar;
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
	
	var hpBar:FlxBar;
	var shieldBar:FlxBar;

	public function new() 
	{
		super();
		CooldownForEvade = 0;
		decision = Decision.NOTDECIDED;
		initStats();
	}
	
	override public function update():Void 
	{
		super.update();
		hpBar.currentValue = currentHP;
		shieldBar.currentValue = currentShield;
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
			if (FlxRandom.intRanged(luck, 100) <= luck) 
			{
				max = weaponPower + level;
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
		var tmpRechargeRate:Float = shieldRecovery / 20;
		var tmp:Float = ((shield - currentShield) * tmpRechargeRate);
		currentShield = Math.round(currentShield + ((shield - currentShield) * tmpRechargeRate));
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
	}
	
	public function SetDecision(dec:Decision)
	{
		this.decision = dec;
		status = Status.WAITING;
	}
	
	private function createBars(player:Bool):Void
	{
		if (player)
		{
			hpBar = new FlxBar(FlxG.width * 0.05, FlxG.height * 0.65, FlxBar.FILL_LEFT_TO_RIGHT, Std.int(FlxG.width * 0.2), Std.int(FlxG.height * 0.05), null, "", 0, hitpoints, true);
			hpBar.createFilledBar(0xFF720000,FlxColor.RED,true);
			add(hpBar);
			
			shieldBar = new FlxBar(FlxG.width * 0.05, FlxG.height * 0.55, FlxBar.FILL_LEFT_TO_RIGHT, Std.int(FlxG.width * 0.2), Std.int(FlxG.height * 0.05), null, "", 0, shield, true);
			add(shieldBar);
		}else
		{
			hpBar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, Std.int(FlxG.width * 0.2), Std.int(FlxG.height * 0.05), null, "", 0, hitpoints, true);
			hpBar.setPosition(FlxG.width * 0.95 - hpBar.width, FlxG.height * 0.65);
			hpBar.createFilledBar(0xFF720000,FlxColor.RED,true);
			add(hpBar);
			
			shieldBar = new FlxBar(0,0, FlxBar.FILL_LEFT_TO_RIGHT, Std.int(FlxG.width * 0.2), Std.int(FlxG.height * 0.05), null, "", 0, shield, true);
			shieldBar.setPosition(FlxG.width * 0.95 - hpBar.width, FlxG.height * 0.55);
			add(shieldBar);
		}
	}
	
	public function GetEnergyValue():Int { return currentEnergy; }
}