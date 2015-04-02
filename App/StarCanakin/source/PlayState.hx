package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.text.FlxTextField;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.addons.display.FlxStarField;

/**
 * Třída pro jeden level
 */
class PlayState extends FlxState
{
	
	var stars:FlxStarField2D;
	var player:Player;
	var enemy:Enemy;
	
	
	
	//Buttons
	var buttonAttack:FlxButton;
	var buttonEvade:FlxButton;
	var buttonBoost:FlxButton;
	var buttonBoostHP:FlxButton;
	var buttonBoostS:FlxButton;
	var buttonBoostSR:FlxButton;
	var buttonBoostExit:FlxButton;

		
	override public function create():Void
	{
		super.create();
		
		stars = new FlxStarField2D();
		stars.setStarSpeed(3,10);
		add(stars);
		
		//FlxG.debugger.drawDebug = true;
		//inicializace komponent lvlu
		player = Player.getPlayer();	//pozor, singleton, při každé smrti je nutné objekt zničit nebo vynulovat			
		enemy = new Enemy();
		
		add(enemy);
		add(player);
		
		
		
		createButtons();	
	}

	
	override public function destroy():Void
	{
		super.destroy();
	}

	
	override public function update():Void
	{
		super.update();
		
		newGameForTest();
		
		//pro kontrolu hráčovy energie
		checkBoost();
		//pro kontrolu cooldownů
		checkCooldowns();
		//pokud oba mají status waiting, tak v této třídě porběhne vyhodnocení akcí
		if (enemy.status == Status.WAITING && player.status == Status.WAITING) 
		{
			//u obou lodí je zavolána funkce pro snížení případných cooldownů
			player.DecreaseCooldowns();
			enemy.DecreaseCooldowns();
			
			trace(" ");
			
			//je načtena a provedena akce enemy
			var eDMG:Int = 0;
			var eEVADATION:Float = 1;
			var eCRIT:Bool = false;
			var eHP:Int = 0;
			var eSHIELD = 0;
			switch (enemy.GetDecision()) 
			{
				case Decision.ATTACK:
					if (player.GetDecision() == Decision.EVADE) 
					{
						eDMG = enemy.Attack();
						trace("Enemy attack without crit: " + eDMG);
					}else{
						eDMG = enemy.Attack(true);
						trace("Enemy attack with crit: " + eDMG);
					}
				case Decision.EVADE:
					eEVADATION = enemy.Evade();
				case Decision.BOOSTHP:
					enemy.Boost(StatName.HealthPoints, true);
				case Decision.BOOSTSHIELD:
					enemy.Boost(StatName.ShieldPoints, true);
				case Decision.BOOSTSHIELDRECOVERY:
					enemy.Boost(StatName.ShieldRecovery, true);		
				case Decision.NOTDECIDED:
					
				default:
			}
			//je načtena a provedena akce playera
			var pDMG:Int = 0;
			var pEVADATION:Float = 1;
			var pCRIT:Bool = false;
			var pHP:Int = 0;
			var pSHIELD = 0;
			switch (player.GetDecision()) 
			{
				case Decision.ATTACK:
					if (enemy.GetDecision() == Decision.EVADE) 
					{
						pDMG = player.Attack();
						trace("Player attack without crit: " + pDMG);
					}else{
						pDMG = player.Attack(true);
						trace("Player attack with crit: " + pDMG);
					}
				case Decision.EVADE:
					pEVADATION = player.Evade();
				case Decision.BOOSTHP:
					player.Boost(StatName.HealthPoints, true);
				case Decision.BOOSTSHIELD:
					player.Boost(StatName.ShieldPoints, true);
				case Decision.BOOSTSHIELDRECOVERY:
					player.Boost(StatName.ShieldRecovery, true);	
				case Decision.NOTDECIDED:
					
				default: 
					
			}
			
			//útok enemy je snížen o evadation playera a poté je odečten od jeho statů
			eDMG = Std.int(eDMG * pEVADATION);
			player.DoDamage(eDMG);
			//útok playera je snížen o evadation enemy a poté je odečten od jeho statů
			pDMG = Std.int(pDMG * eEVADATION);
			enemy.DoDamage(pDMG);

			
			
			//nastavit obě lodě na done			
			enemy.status = Status.DONE;
			player.status = Status.DONE;
		}
		if (enemy.status == Status.DONE && player.status == Status.DONE)
		{
			//nastavit obě lodě na nerozhodnutý stav
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
	
	
//{ BUTTON METHODS
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
	private function BoostHPButton() 
	{ 
		player.SetDecision(Decision.BOOSTHP);
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
	
	private function createButtons():Void
	{
		//Buttons
		buttonAttack = new FlxButton(0,0, "Attack", AttackButton);
		buttonAttack.setPosition(FlxG.width * 0.3-buttonAttack.width, FlxG.height * 0.8);
		add(buttonAttack);
		
		buttonEvade = new FlxButton(0,0, "Evade", EvadeButton);
		buttonEvade.setPosition(FlxG.width*0.6 - buttonEvade.width, FlxG.height * 0.8);
		add(buttonEvade);
		
		buttonBoost = new FlxButton(0, 0, "Boost", BoostButton);
		buttonBoost.setPosition(FlxG.width * 0.9 - buttonBoost.width, FlxG.height * 0.8);
		add(buttonBoost);
		
		buttonBoostExit = new FlxButton(440, 350, "Back", BoostExitButton);
		buttonBoostExit.visible = false;
		add(buttonBoostExit);
		
		buttonBoostHP = new FlxButton(200, 300, "Hull", BoostHPButton);
		buttonBoostHP.visible = false;
		add(buttonBoostHP);
		
		buttonBoostS = new FlxButton(440, 300, "Shield", BoostSButton);
		buttonBoostS.visible = false;
		add(buttonBoostS);
		
		buttonBoostSR = new FlxButton(200, 350, "Shield recovery", BoostSButton);
		buttonBoostSR.visible = false;
		add(buttonBoostSR);
		
		
	}
	/**
	 * Pokud hráč nemá žádnou volnou energii, zmizí mu boostovací tlačítko.
	 */
	private function checkBoost()
	{
		if (player.GetEnergyValue() == 0 ) 
		{
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
	}
//}
}