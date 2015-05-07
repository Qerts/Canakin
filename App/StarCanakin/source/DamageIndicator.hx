package;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.util.FlxColorUtil.ARGB;
import flixel.util.FlxTimer;
using flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import haxe.Timer;



/**
 * ...
 * @author Qerts
 * Tato třída slouží k vytváření plovoucích hodnot poškození.
 */
class DamageIndicator extends FlxSpriteGroup
{
	var dmgLabel:FlxText;
	var flyToTheLeft:Bool;
	var fadeTime:Int;

	public function new(x:Int, y:Int, dmg:Int, left:Bool = true, color:Int = 0xffffff, miliseconds:Int = 4000) 
	{
		super();
		
		dmgLabel = new FlxText(x, y, 200, "", 10);
		dmgLabel.color = color;
		dmgLabel.text = " " + dmg + " ";
		flyToTheLeft = left;
		fadeTime = miliseconds;
		add(dmgLabel);
		
		var timer = new FlxTimer(miliseconds / 100000, DecreaseOpacity, 10);
	}
	
	override function update()
	{
		super.update();
		
		if (flyToTheLeft) 
		{
			dmgLabel.x--;
			dmgLabel.y--;
		}else 
		{
			dmgLabel.x++;
			dmgLabel.y--;
		}	
	}
	
	private function DecreaseOpacity(Timer:FlxTimer):Void
	{
		dmgLabel.alpha -= 0.1;
		if (dmgLabel.alpha <= 0) 
		{
			this.destroy();	
		}
		
	}
	
}