package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.text.FlxTextField;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.addons.display.FlxStarField;
import flixel.util.FlxColor;

/**
 * Třída pro jeden level
 */
class PlayState extends FlxState
{
	//UI declarations
	var stars:FlxStarField2D;
	var buttonsBackground:FlxSprite;
	
	//Ship declarations
	var player:Player;
	var playerDMG:Int = 0;
	var playerEVADATION:Float = 1;
	var playerCRIT:Bool = false;
	var playerHP:Int = 0;
	var playerSHIELD = 0;
	
	var enemy:Enemy;
	var enemyDMG:Int = 0;
	var enemyEVADATION:Float = 1;
	var enemyCRIT:Bool = false;
	var enemyHP:Int = 0;
	var enemySHIELD = 0;
		
	//Button declarations
	var buttonAttack:FlxButton;
	var buttonEvade:FlxButton;
	var buttonBoost:FlxButton;
	var buttonBoostHP:FlxButton;
	var buttonBoostS:FlxButton;
	var buttonBoostSR:FlxButton;
	var buttonBoostExit:FlxButton;
	var buttonAimForWeapons:FlxButton;
	var buttonAimForShields:FlxButton;
		
	override public function create():Void
	{
		super.create();
		
		//inicializace prostředí
		SetStars();
		SetButtonsBakcground();
		SetButtons();
		
		//inicializace lodí
		player = Player.getPlayer();	
		add(player);
		enemy = new Enemy();	
		add(enemy);		
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}
	
	override public function update():Void
	{
		super.update();
		
		//testovací scénář
		newGameForTest();
		
		//obsluha tlačítek
		buttonService();
		
		if (enemy.status == Status.WAITING && player.status == Status.WAITING) 
		{
			player.DecreaseCooldowns();
			enemy.DecreaseCooldowns();	
			
			clensShipValues();
			
			//PROVEDENÍ AKCE DLE ROZHODNUTÍ CPU
			switch (enemy.GetDecision()) 
			{
				case Decision.ATTACK:
					if (player.GetDecision() == Decision.EVADE) 
					{
						enemyDMG = enemy.Attack();
						trace("Enemy attack without crit: " + enemyDMG);
					}else{
						enemyDMG = enemy.Attack(true);
						trace("Enemy attack with crit: " + enemyDMG);
					}
					//útok enemy je snížen o evadation playera a poté je odečten od jeho statů			
					enemyDMG = Std.int(enemyDMG * playerEVADATION);
					player.DoDamage(enemyDMG);
				case Decision.EVADE:
					enemyEVADATION = enemy.Evade();
				case Decision.BOOSTWP:
					enemy.Boost(StatName.WeaponPower, true);
				case Decision.BOOSTSHIELD:
					enemy.Boost(StatName.ShieldPoints, true);
				case Decision.BOOSTSHIELDRECOVERY:
					enemy.Boost(StatName.ShieldRecovery, true);		
				case Decision.NOTDECIDED:
				case Decision.AIMSHIELDS:
					player.AimedForShields(enemy.AimForShields());
				case Decision.AIMWEAPONS:
					player.AimedForWeapons(enemy.AimForWeapons());
					
			}
			
			//PROVEDENÍ AKCE DLE ROZHODNUTÍ HRÁČE
			switch (player.GetDecision()) 
			{
				case Decision.ATTACK:
					if (enemy.GetDecision() == Decision.EVADE) 
					{
						playerDMG = player.Attack();
						trace("Player attack without crit: " + playerDMG);
					}else{
						playerDMG = player.Attack(true);
						trace("Player attack with crit: " + playerDMG);
					}
					//útok playera je snížen o evadation enemy a poté je odečten od jeho statů
					playerDMG = Std.int(playerDMG * enemyEVADATION);
					enemy.DoDamage(playerDMG);	
				case Decision.EVADE:
					playerEVADATION = player.Evade();
				case Decision.BOOSTWP:
					player.Boost(StatName.WeaponPower, true);
				case Decision.BOOSTSHIELD:
					player.Boost(StatName.ShieldPoints, true);
				case Decision.BOOSTSHIELDRECOVERY:
					player.Boost(StatName.ShieldRecovery, true);	
				case Decision.NOTDECIDED:
				case Decision.AIMSHIELDS:
					enemy.AimedForShields(player.AimForShields());
				case Decision.AIMWEAPONS:
					enemy.AimedForWeapons(player.AimForWeapons());
			}
			
			
					
			
			//nastavit obě lodě na done			
			enemy.status = Status.DONE;
			player.status = Status.DONE;
		}
		if (enemy.status == Status.DONE && player.status == Status.DONE)
		{
			//nastavit obě lodě na nerozhodnutý stav, čímž se vynuluje jejich rozhodnutí, dokud nebude nahrazeno nějakou akcí
			player.SetDecision(Decision.NOTDECIDED);
			enemy.SetDecision(Decision.NOTDECIDED);
			
			//lodím jsou dobity štíty
			player.RechargeShield();
			enemy.RechargeShield();
			
			//pokud jsou dokončený všechny případné akce stavu done, přepne se znovu na starting
			enemy.status = Status.STARTING;
			player.status = Status.STARTING;
		}
		
	}
	
	private function newGameForTest():Void
	{
		if (enemy.GetHull() < 1 || player.GetHull() < 1)
		{
			enemy.destroy();
			player.destroy();
			
			player = new Player();	//pozor, singleton, při každé smrti je nutné objekt zničit nebo vynulovat			
			enemy = new Enemy();
			
			add(player);
			add(enemy);
			
		}
	}
	
	private function clensShipValues()
	{
		playerDMG = 0;
		playerEVADATION = 1;
		playerCRIT = false;
		playerHP = 0;
		playerSHIELD = 0;
	
		enemyDMG = 0;
		enemyEVADATION = 1;
		enemyCRIT = false;
		enemyHP = 0;
		enemySHIELD = 0;
	}
	
//{ USER INTERFACE, INCLUDING BUTTONS
	/**
	 * Vytvoří v pozadí nekonečný vesmír plný hvězd zářících jako rozsypaný náhrdelník z perel.
	 */
	private function SetStars()
	{
		stars = new FlxStarField2D();
		stars.setStarSpeed(3,10);
		add(stars);
	}
	/**
	 * Vytvoří panel pro tlačítka.
	 */
	private function SetButtonsBakcground()
	{
		buttonsBackground = new FlxSprite();
		buttonsBackground.makeGraphic(FlxG.width, Std.int(FlxG.height * 0.5), FlxColor.GRAY);
		buttonsBackground.setPosition(0, FlxG.height * 0.5);
		add(buttonsBackground);
	}
	/**
	 * Initializuje tlačítka.
	 */
	private function SetButtons():Void
	{
		//Buttons
		buttonAttack = new FlxButton(0, 0, "", AttackButton);
		buttonAttack.loadGraphic("assets/images/buttons/attack_button.png");
		buttonAttack.setPosition(FlxG.width * 0.3 - (buttonAttack.width / 2), FlxG.height * 0.75);
		add(buttonAttack);
		
		buttonEvade = new FlxButton(0, 0, "", EvadeButton);
		buttonEvade.loadGraphic("assets/images/buttons/evade_button.png");
		buttonEvade.setPosition(FlxG.width*0.5 - (buttonEvade.width/2), FlxG.height * 0.75);
		add(buttonEvade);
		
		buttonBoost = new FlxButton(0, 0, "", BoostButton);
		buttonBoost.loadGraphic("assets/images/buttons/boost_button.png",false,128,128,false);
		buttonBoost.setPosition(FlxG.width * 0.7 - (buttonBoost.width/2), FlxG.height * 0.75);
		add(buttonBoost);
		
		buttonBoostExit = new FlxButton(0, 0, "Back", BoostExitButton);
		buttonBoostExit.setPosition(FlxG.width * 0.7 -(buttonBoostExit.width / 2), FlxG.height * 0.9);
		buttonBoostExit.visible = false;
		add(buttonBoostExit);
		
		buttonBoostHP = new FlxButton(0,0, "Weapons", BoostWPButton);
		buttonBoostHP.setPosition(FlxG.width * 0.3 -(buttonBoostHP.width / 2), FlxG.height * 0.8);
		buttonBoostHP.visible = false;
		add(buttonBoostHP);
		
		buttonBoostS = new FlxButton(0,0, "Shield", BoostSButton);
		buttonBoostS.setPosition(FlxG.width * 0.5 -(buttonBoostS.width / 2), FlxG.height * 0.8);
		buttonBoostS.visible = false;
		add(buttonBoostS);
		
		buttonBoostSR = new FlxButton(0,0, "Generator", BoostSRButton);
		buttonBoostSR.setPosition(FlxG.width * 0.7 - (buttonBoostSR.width / 2), FlxG.height * 0.8);
		buttonBoostSR.visible = false;
		add(buttonBoostSR);
		
		buttonAimForShields = new FlxButton(0,0, "Aim shields", AimShields);
		buttonAimForShields.setPosition(FlxG.width * 0.3 - (buttonAimForShields.width / 2), FlxG.height * 0.9);
		add(buttonAimForShields);
		
		buttonAimForWeapons = new FlxButton(0,0, "Aim weapons", AimWeapons);
		buttonAimForWeapons.setPosition(FlxG.width * 0.5 - (buttonAimForWeapons.width / 2), FlxG.height * 0.9);
		add(buttonAimForWeapons);
		
		
	}
//}
//{ BUTTON METHODS

	private function buttonService()
	{
		//pro kontrolu hráčovy energie
		checkBoost();
		//pro kontrolu cooldownů
		checkCooldowns();
	}
	private function AttackButton()
	{
		player.SetDecision(Decision.ATTACK);
	}
	private function EvadeButton()
	{
		player.SetDecision(Decision.EVADE);
	}
	private function BoostButton() 
	{
		buttonBoost.visible = false;
		buttonBoostExit.visible = true;
		buttonAttack.visible = false;
		buttonBoostHP.visible = true;
		buttonBoostS.visible = true;
		buttonBoostSR.visible = true;
		buttonEvade.visible = false;		
	}
	private function BoostWPButton() 
	{ 
		player.SetDecision(Decision.BOOSTWP);
	}
	private function BoostSButton() 
	{
		player.SetDecision(Decision.BOOSTSHIELD);
	}
	private function BoostSRButton() 
	{
		player.SetDecision(Decision.BOOSTSHIELDRECOVERY);
	}
	private function BoostExitButton() 
	{
		buttonBoost.visible = true;
		buttonBoostExit.visible = false;
		buttonAttack.visible = true;
		buttonBoostHP.visible = false;
		buttonBoostS.visible = false;
		buttonBoostSR.visible = false;
		buttonEvade.visible = true;
	}
	
	private function AimWeapons()
	{
		player.SetDecision(Decision.AIMWEAPONS);
	}
	
	private function AimShields()
	{
		player.SetDecision(Decision.AIMSHIELDS);
	}
	
	/**
	 * Pokud hráč nemá žádnou volnou energii, zmizí mu boostovací tlačítko.
	 */
	private function checkBoost()
	{
		if (player.GetEnergyValue() == 0 || buttonBoostExit.visible == true) 
		{
			buttonBoost.visible = false;
		}else 
		{
			buttonBoost.visible = true;
		}
		if (player.GetEnergyValue() == 0) 
		{
			BoostExitButton();
			buttonBoost.visible = false;
		}
	}
	private function checkCooldowns()
	{
		if (player.CooldownForEvade > 0)
		{
			buttonEvade.visible = false;
		}
		else 
		{
			buttonEvade.visible = true;
		}
		if (player.CooldownForWeapons > 0) 
		{
			buttonAttack.visible = false;
		}else 
		{
			buttonAttack.visible = true;
		}
		
		if (player.CooldownForAimForShields > 0) 
		{
			buttonAimForShields.visible = false;
		}else 
		{
			buttonAimForShields.visible = true;
		}
		
		if (player.CooldownForAimForWeapons > 0) 
		{
			buttonAimForWeapons.visible = false;
		}else 
		{
			buttonAimForWeapons.visible = true;
		}
		
		if (player.CooldownForAimForShields > 0) 
		{
			buttonAimForWeapons.visible = false;
		}else 
		{
			buttonAimForShields.visible = true;
		}
	}
//}
}