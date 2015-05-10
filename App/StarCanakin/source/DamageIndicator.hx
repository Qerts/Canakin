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

	/**
	 * 
	 * @param	x Horizontální pozice čísla
	 * @param	y Vertikální pozice čísla
	 * @param	dmg Text
	 * @param	left Zda číslo bude plout doleva. Pokud je false, popluje doprava.
	 * @param   delay Zpoždění animace v milisekundách
	 * @param	color Barva písma, zadat ve formátu 0x000000
	 * @param	miliseconds Počet milisekund, po které bude číslo viditelné
	 */
	public function new(x:Int, y:Int, text:String, left:Bool = true, delay:Int = 0, color:Int = 0xffffff, miliseconds:Int = 4000, fonsize:Int = 15) 
	{
		super();
		
		
		dmgLabel = new FlxText(x, y, 200, getQuote(Std.int(Std.parseFloat(text))) , fonsize);
		dmgLabel.color = color;
		flyToTheLeft = left;
		fadeTime = miliseconds;
		add(dmgLabel);
		
		var timer = new FlxTimer(miliseconds / 10000, DecreaseOpacity, 10);
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
	
	private function getQuote(percent:Int):String
	{
		switch (percent) 
		{
			case 1|2|3|4|5|6|7|8|9|10:
				return "WARNING! EVACUATE IMMEDIATELY!";
			case 11|12|13|14|15|16|17|18|19|20:
				return "Life support is failing...";
			case 21|22|23|24|25|26|27|28|29|30:
				return "Generator damaged!";
			case 31|32|33|34|35|36|37|38|39|40:
				return "CPU on 36%, recomme§@#&&%...";
			case 41|42|43|44|45|46|47|48|49|50:
				return "Fire on deck 1, 3, 4";
			case 51|52|53|54|55|56|57|58|59|60:
				return "Ship is severely damaged, return to dock";
			case 61|62|63|64|65|66|67|68|69|70:
				return "Support systems hit, countermeasures initiated";
			case 71|72|73|74|75|76|77|78|79|80:
				return "Breach in cargo deck, no casualties";
			case 81|82|83|84|85|86|87|88|89|90:
				return "This will leave some scratches";
			case 91|92|93|94|95|96|97|98|99|100:
				return "Shield is failing, regarge before proceeding";
			case 101|102|103|104|105|106|107|108|109|110:
				return "Shield is on lowest level";
			case 111|112|113|114|115|116|117|118|119|120:
				return "Shield integrity disrupted";
			case 121|122|123|124|125|126|127|128|129|130:
				return "Shiled can't stand much more";
			case 131|132|133|134|135|136|137|138|139|140:
				return "Shield power is at half";
			case 141|142|143|144|145|146|147|148|149|150:
				return "Shield's condition is not well";
			case 151|152|153|154|155|156|157|158|159|160:
				return "Shield needs more power";
			case 161|162|163|164|165|166|167|168|169|170:
				return "Shield is on 60% of its power";
			case 171|172|173|174|175|176|177|178|179|180:
				return "Shield integrity incomplete";
			case 181|182|183|184|185|186|187|188|189|190:
				return "Shield is dwindling";
			case 191|192|193|194|195|196|197|198|199|200:			
				return "Shiled is on 90%";
				
				
			default:
				
		}
		return "error";
	}
	
}