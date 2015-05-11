package states;
import flixel.FlxState;
import flixel.FlxG;

/**
 * ...
 * @author w
 */
class GameOverState extends FlxState
{
	var player:Player;
	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		super.create();
		Player.getPlayer().resetStats();
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (FlxG.mouse.justPressed)
		{
			FlxG.switchState(new PlayState());
		}
	}
}