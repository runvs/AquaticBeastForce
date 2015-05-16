package ;
import flixel.FlxSprite;
import flixel.util.FlxColorUtil;

/**
 * ...
 * @author 
 */
class Workshop extends GameObject
{

	public function new(state:PlayState) 
	{
		super();
		_state = state;
		
		sprite = new FlxSprite();
		sprite.makeGraphic(32, 32, FlxColorUtil.makeFromARGB(1.0, 32, 38, 94));
	}
	
	override public function update():Void 
    {
		super.update();
		sprite.update();// for animations etc.
		sprite.x = x;
		sprite.y = y;
	
	}
	
	public override function draw():Void
    {
		//trace("draw");
		super.draw();
		sprite.draw();
	}
	
}