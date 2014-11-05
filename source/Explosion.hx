package ;

import flixel.FlxSprite;

/**
 * ...
 * @author 
 */
class Explosion extends FlxSprite
{

	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.explo1__png, true, 16, 16);
		animation.add("explode", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 20, false);
		animation.play("explode");
	}
	
	public override function update():Void
	{
		if (animation.finished)
		{
			kill();
		}
		super.update();
	}
	
}