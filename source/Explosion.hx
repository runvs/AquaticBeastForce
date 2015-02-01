package ;

import flixel.addons.api.FlxGameJolt;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.tweens.FlxTween;
import flixel.util.FlxColorUtil;
import flixel.util.FlxTimer;

/**
 * ...
 * @author 
 */
class Explosion extends FlxSprite
{

	public var _isSmallExplosion:Bool;
	private var _soundExplosion : FlxSound;
	
	public function new(X:Float=0, Y:Float=0, smallExplosion:Bool = false, slowDown:Bool = false)
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
		
		if (!smallExplosion && slowDown)
		{
			FlxG.camera.flash(FlxColorUtil.makeFromARGB(0.8, 242, 249, 246), 0.15);
			var t : FlxTimer = new FlxTimer(0.14, function (t:FlxTimer) : Void 
			{
				FlxG.timeScale = 0.05; 
				FlxTween.tween(FlxG, { timeScale : 1.0 }, 0.2 );
			} );
			
			
		}
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