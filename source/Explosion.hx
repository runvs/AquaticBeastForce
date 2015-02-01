package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;

/**
 * ...
 * @author 
 */
class Explosion extends FlxSprite
{

	public var _isSmallExplosion:Bool;
	private var _soundExplosion : FlxSound;
	
	public function new(X:Float=0, Y:Float=0, smallExplosion:Bool = false)
	{
		super(X, Y);
		_isSmallExplosion = smallExplosion;
        // Load the right graphics for the explosion
        if (smallExplosion)
        {
            loadGraphic(AssetPaths.explosionSmall__png, true, 16, 16);
        }
        else
        {
            loadGraphic(AssetPaths.explo1__png, true, 16, 16);
        }
        
		animation.add("explode", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 20, false);
		animation.play("explode");
		
		_soundExplosion = new FlxSound();
        _soundExplosion = FlxG.sound.load(AssetPaths.Explo__ogg, (smallExplosion)? 0.125 : 0.75 , false, false , false);
        
		_soundExplosion.play();
	}
	
	public override function update():Void
	{
		if (animation.finished)
		{
			alive = false;
			kill();
		}
		super.update();
	}
	
}