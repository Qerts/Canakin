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
		//pro kontrolu hráčovy energie
		checkBoost();
		//pokud oba mají status waiting, tak v této třídě porběhne vyhodnocení akcí
		if (enemy.status == Status.WAITING && player.status == Status.WAITING) 
		{
			//je načtena a provedena akce enemy
			var eDMG:Int = 0;
			var eEVADATION:Float = 1;
			var eCRIT:Bool = false;
			var eHP:Int = 0;
			var eSHIELD = 0;
			switch (enemy.GetDecision()) 
			{
				case Decision.ATTACK:
					eDMG = enemy.Attack();
					trace("enemydmg:" + eDMG);
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
					pDMG = player.Attack();
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
			trace("dmg - evadation - výpočet", eDMG, pEVADATION, Std.int(eDMG * pEVADATION), pDMG, eEVADATION, Std.int(pDMG * eEVADATION));
			//útok enemy je snížen o evadation playera a poté je odečten od jeho statů
			eDMG = Std.int(eDMG * pEVADATION);
			player.DoDamage(eDMG);
			//útok playera je snížen o evadation enemy a poté je odečten od jeho statů
			pDMG = Std.int(pDMG * eEVADATION);
			enemy.DoDamage(pDMG);

			
			//u obou lodí je zavolána funkce pro snížení případných cooldownů
			player.DecreaseCooldowns();
			enemy.DecreaseCooldowns();
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
		buttonAttack.setPosition(FlxG.width * 0.2, FlxG.height * 0.6);
		add(buttonAttack);
		
		buttonBoost = new FlxButton(0, 0, "Boost", BoostButton);
		buttonBoost.setPosition(FlxG.width*0.8-buttonBoost.width, FlxG.height * 0.6);
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
		
		buttonEvade = new FlxButton(0,0, "Evade", EvadeButton);
		buttonEvade.setPosition(FlxG.width*0.8-buttonBoost.width, FlxG.height * 0.7);
		add(buttonEvade);
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
//}
}