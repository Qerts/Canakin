package states ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.text.FlxTextField;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.addons.display.FlxStarField;
import flixel.util.FlxColor;
import haxe.Timer;
import openfl.display.Graphics;

/**
 * Třída pro jeden level
 */
class PlayState extends FlxState
{
	//UI declarations
	var stars:FlxStarField2D;
	var buttonsBackground:FlxSprite;
	var statsCircle:FlxSprite;
	
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
		
	
	
	var crack1:FlxSprite;
	var crack2:FlxSprite;
	var crack3:FlxSprite;
	
	
	var ui:UserInterface;
	
	
	override public function create():Void
	{
		super.create();
		
		
		//inicializace prostředí
		SetStars();
		SetUI();
		//SetButtonsBakcground();
		//SetButtons();
		
		//inicializace lodí
		player = Player.getPlayer();		
		add(player);
		enemy = new Enemy();	
		add(enemy);		
		
		createCracks();
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}
	
	override public function update():Void
	{
		super.update();
		
		updateCracks();
		//testovací scénář
		
		//newGameForTest();
		CheckForDeath();
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
					//set projectile
					var projectile:Projectile = new Projectile(Std.int(enemy.x + enemy.width * 0.05), Std.int(enemy.y + enemy.height * 0.5), Std.int(player.x + player.width * 0.8), Std.int(player.y + player.height * 0.5), ProjectileType.Laser, 0, 10);
					add(projectile);
					
					
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
					var projectile:Projectile = new Projectile(Std.int(enemy.x + enemy.width * 0.05), Std.int(enemy.y + enemy.height * 0.5), Std.int(player.x + player.width * 0.8), Std.int(player.y + player.height * 0.5), ProjectileType.ShieldAimedMissile, 0, 10);
					add(projectile);
					player.AimedForShields(enemy.AimForShields());
				case Decision.AIMWEAPONS:
					var projectile:Projectile = new Projectile(Std.int(enemy.x + enemy.width * 0.05), Std.int(enemy.y + enemy.height * 0.5), Std.int(player.x + player.width * 0.8), Std.int(player.y + player.height * 0.5), ProjectileType.WeaponAimedMissile, 0, 10);
					add(projectile);
					player.AimedForWeapons(enemy.AimForWeapons());
					
			}
			
			//PROVEDENÍ AKCE DLE ROZHODNUTÍ HRÁČE
			switch (player.GetDecision()) 
			{
				case Decision.ATTACK:
					var projectile = new Projectile(Std.int(player.x + player.width * 0.8), Std.int(player.y + player.height * 0.5), Std.int(enemy.x + enemy.width * 0.1), Std.int(enemy.y + player.height * 0.5), ProjectileType.Laser, 0, 10);
					add(projectile);
					
					
					
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
					var projectile = new Projectile(Std.int(player.x + player.width * 0.8), Std.int(player.y + player.height * 0.5), Std.int(enemy.x + enemy.width * 0.1), Std.int(enemy.y + player.height * 0.5), ProjectileType.ShieldAimedMissile, 0, 10);
					add(projectile);
					enemy.AimedForShields(player.AimForShields());
				case Decision.AIMWEAPONS:
					var projectile = new Projectile(Std.int(player.x + player.width * 0.8), Std.int(player.y + player.height * 0.5), Std.int(enemy.x + enemy.width * 0.1), Std.int(enemy.y + player.height * 0.5), ProjectileType.WeaponAimedMissile, 0, 10);
					add(projectile);
					enemy.AimedForWeapons(player.AimForWeapons());
			}
			
			ui.SetEnergy(player.GetEnergyValue(), player.GetMaxEnergyValue());
			ui.SetHitpoints(player.GetHull(), player.GetMaxHull());
			ui.SetShield(player.GetShield(), player.GetMaxShield());
			
					
			
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
	
	private function CheckForDeath():Void
	{
		if (enemy.GetHull() < 1)
		{
			player.destroy();
			player = new Player();
			FlxG.switchState(new NextBattleState());
		}
		
		if (player.GetHull() < 1)
		{
			player.destroy();
			player = new Player();
			FlxG.switchState(new GameOverState());
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
	private function SetUI()
	{
		ui = new UserInterface();
		ui.setPosition(0,0);
		add(ui);
	}
	/**
	 * Vytvoří v pozadí nekonečný vesmír plný hvězd zářících jako rozsypaný náhrdelník z perel.
	 */
	private function SetStars()
	{
		stars = new FlxStarField2D();
		stars.setStarSpeed(3,10);
		add(stars);
	}
	
	
//}
//{ BUTTON METHODS

	private function buttonService()
	{
		var values = ui.GetPushedButtons();
		if (values[0]) 
		{
			player.SetDecision(Decision.ATTACK);
		}else 
		{
			if (values[1]) 
			{
				player.SetDecision(Decision.EVADE);
			}else 
			{
				if (values[2]) 
				{
					player.SetDecision(Decision.AIMWEAPONS);
				}else 
				{
					if (values[3]) 
					{
						player.SetDecision(Decision.AIMSHIELDS);
					}else 
					{
						if (values[4]) 
						{
							switch(ui.GetBoostStat())
							{
								case StatName.EnergyLevel:
								case StatName.HealthPoints:
								case StatName.Luck:
								case StatName.ShieldPoints:
									player.SetDecision(Decision.BOOSTSHIELD);
								case StatName.ShieldRecovery:
									player.SetDecision(Decision.BOOSTSHIELDRECOVERY);
								case StatName.WeaponPower:
									player.SetDecision(Decision.BOOSTWP);
									
							}
						}
					}	
				}	
			}
		}
	}
	
	
	
	
	
	
	
	
	
	
	private function createCracks()
	{
		crack1 = new FlxSprite(FlxG.camera.x,FlxG.camera.y,"assets/images/glass_crack1.png");
		crack1.visible = false;
		add(crack1);
		
		crack2 = new FlxSprite(0,0,"assets/images/glass_crack2.png");
		crack2.visible = false;
		add(crack2);
		
		crack3 = new FlxSprite(0,0,"assets/images/glass_crack3.png");
		crack3.visible = false;
		add(crack3);
	}
	
	private function updateCracks()
	{
		if (player.currentHpPercentage < 60)
		{
			crack1.visible = true;
		}
		
		if (player.currentHpPercentage < 40)
		{
			crack2.visible = true;
		}
		
		if (player.currentHpPercentage < 20)
		{
			crack3.visible = true;
		}
		
		if (player.currentHpPercentage >= 100)
		{
			crack1.visible = false;
			crack2.visible = false;
			crack3.visible = false;
		}
	}
//}
}