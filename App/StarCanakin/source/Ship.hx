package;
import flixel.group.FlxSpriteGroup;
using flixel.util.FlxRandom;

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
	var hitpointsTmp:Int;
	var shieldTmp:Int;
	var shieldRecoveryTmp:Int;
	var weaponPowerTmp:Int;
	var energyLevelTmp:Int;
	var luckTmp:Int;
	
	//aktuální hodnoty
	var currentHP:Int;
	var currentShield:Int;
	var currentEnergy:Int;
	
	public var level:Int;
	
	//Cooldowny
	public var CooldownForEvade:Int;

	public function new() 
	{
		super();	
		
		CooldownForEvade = 0;
		decision = Decision.NOTDECIDED;
		
						//pro testovací účely, smazat
		initStats();
	}
	
	private function initStats(level:Int = 1) 
	{
		/*
		 * Rozdělování statsů
		- HP - rozmezí 6(+lvl) - 8 (+lvl). Při přirozeném postupu hráče se HP zvyšují samostatně z každým lvl.
		- Energy  - pouze 1 za bitvu ANEBO jestliže je HP rozmezí v dolní hranici tak energy je 2 a jestliže je v horní tak 1. Tzn na lvl 1 jestliže je 7 nebo 8 HP,energy je 2. Jestliže je 8 - 9 hp, energy je 1
		- Luck - (návrh přejmenování na instinct) - 5 na začátku, s každým levelem se zvyšuje náhodně v rozmezí 2 - 4 (anebo 2 - 3 - možnost modifikace). Tento údaj je procento. Ještě nevím jestli luck má být pouze u hráče anebo i u nepřítele. Uvidíme
		- 3 statsy - shield, shield recovery a weapon power - 10 + lvl bodů:
		-  weapon power - dolní rozmezi 3 (+ lvl) - horní rozmezí - 5 (+lvl)
		- Shield + shield recovery - bez rozmezí, minimální počet bodů je 2
		*/
		
		
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
		//trace(totalPoints);
		
		while (totalPoints != 0)
		{
			var rand = FlxRandom.intRanged(0, 100);
			trace(rand);
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
		
		/*
		var lvlForSum:Int = Std.int(level / 2);
		var pointsLeft:Int = 18 + level;				//body, které zbývají k rozdělení
		
		//připsání všem vlastnostem polovinu lvlu a 1, což je minimum	
		hitpoints = 1 + lvlForSum;						
		shield = 1 + lvlForSum;
		shieldRecovery = 1 + lvlForSum;
		weaponPower = 1 + lvlForSum;
		energyLevel = 1 + lvlForSum;
		luck = 1 + lvlForSum;
		
		//upsání přidaných bodů z pointsLeft
		pointsLeft -= 6 + lvlForSum * 6;
		
		//random rovnoměrné rozhození bodů do všech vlastností tak, aby žádná neměla základ větší než 4
		while (pointsLeft != 0) 
		{
			switch (FlxRandom.intRanged(1,6)) 
			{
				case 1:
					if (hitpoints <= 4) 
					{
						hitpoints++;
						pointsLeft--;
					}
				case 2:
					if (shield <= 4) 
					{
						shield++;
						pointsLeft--;
					}
				case 3:	
					if (shieldRecovery <= 4) 
					{
						shieldRecovery++;
						pointsLeft--;
					}
				case 4:
					if (weaponPower <= 4) 
					{
						weaponPower++;
						pointsLeft--;
					}
				case 5:
					if (energyLevel <= 4) 
					{
						energyLevel++;
						pointsLeft--;
					}
				case 6:	
					if (luck <= 4) 
					{
						luck++;
						pointsLeft--;
					}
			}
		}
		*/
		shield = Std.int(shield * level);
		currentEnergy = energyLevel;
		currentHP = hitpoints;
		currentShield = shield;
		
		hitpointsTmp = 0;
		shieldTmp = 0;
		shieldRecoveryTmp = 0;
		weaponPowerTmp = 0;
		energyLevelTmp = 0;
		luckTmp = 0;
		
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
		
	///
	//Tato metoda vypočte a vrátí hodnotu útoku. Viz pravidlo v OneNote
	///
	public function Attack():Int
	{
		trace(weaponPower, level);
		var min:Int = weaponPower -1;
		var max:Int = weaponPower +1;
		//jestli projde critical hit (nastaveno na 10%)
		if (FlxRandom.intRanged(luck, 100) <= 10) 
		{
			max = weaponPower + level;
			return FlxRandom.intRanged(min, max);
		}		
		return FlxRandom.intRanged(min, max);
	}
	///
	//Tato metoda vypočte a vrátí hodnotu uhnutí, která je uvedena v rozmezí 1 - 10 a reprezentuje procenta.
	//Overpower štěstí by mělo být řešeno omezením velikosti statu luck.
	///
	public function Evade():Float
	{
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
	
	///
	//Tato metoda vrací hodnotu štítu pro použití ve vyhodnocení střetu.
	///
	public function GetHull():Int 
	{
		return currentHP;
	}/*
	///
	//Tato metoda vrací hodnotu štítu pro použití ve vyhodnocení střetu.
	///
	public function GetEnergy():Int 
	{
		return currentEnergy;
	}	*/
	/**
	 * Tato metoda by měla být volána na začátku nebo konci každého kola pro obnovéení štítu v závislosti na shieldRecovery.
	 */
	public function RechargeShield()
	{
		currentShield += shieldRecovery;
		if (currentShield > shield) 
		{
			currentShield = shield;
		}
	}
	/**
	 * Tato metoda slouží k poškození lodi. Poškodí štít a pokud jej zničí a projde skrze, poškodí loď.
	 * @param	dmg intagerová hodnota čistého dmg, která bude rovnou počítána se štítem a HP dané lodi
	 */
	public function DoDamage(dmg:Int) 
	{ 
		var sumHeatlth:Int = currentHP + currentShield - dmg;
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
		
	}	
	///
	//Tato metoda by měla být použita pro boostnutí vlastností. Její první vstupní parametr je vlastnost, která bude boostnuta. 
	//Její druhý parametr je příznak, zda použít boost jen dočasně nebo trvale. Druhá možnost je určena pro použití v lvlování.	
	///
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
					energyLevelTmp++;
					currentEnergy--;
				case StatName.HealthPoints:
					hitpointsTmp++;
					currentEnergy--;
				case StatName.Luck:
					luckTmp++;
					currentEnergy--;
				case StatName.ShieldPoints:
					shieldTmp++;
					currentEnergy--;
				case StatName.ShieldRecovery:
					shieldRecoveryTmp++;
					currentEnergy--;
				case StatName.WeaponPower:
					weaponPowerTmp++;	
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
		trace(this.decision);
		status = Status.WAITING;
	}
}