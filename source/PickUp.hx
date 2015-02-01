package ;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;

/**
 * ...
 * @author 
 */
class PickUp extends FlxSprite
{
	public  var _type : PickUpTypes;
	public static function getRandomPickupType (): PickUpTypes
    {
        var maxNumber = PickUpTypes.getConstructors().length -1;  
        
        var retval: PickUpTypes = PickUpTypes.createByIndex(FlxRandom.intRanged(0, maxNumber));

        return retval;
    }
	
	public function new(pos:FlxPoint) 
	{
		super();
		getRandomType();
		setPosition(pos.x, pos.y);
		scale.set(0.9, 0.9);
		FlxTween.tween(this.scale, { x:1.2, y: 1.2 }, 1, { type: FlxTween.PINGPONG } );
		FlxTween.tween(this, { alpha:0.8}, 1, { type: FlxTween.PINGPONG , startDelay: 1.0} );
	}
	
	private function getRandomType() : Void 
	{
		_type = getRandomPickupType();
		
		if (_type == PickUpTypes.Points1)
		{
			loadGraphic(AssetPaths.pickup_points1__png, false, 16, 16);
		}
		else if (_type == PickUpTypes.Points2)
		{
			loadGraphic(AssetPaths.pickup_points2__png, false, 16, 16);
		}
		else if (_type == PickUpTypes.Points5)
		{
			loadGraphic(AssetPaths.pickup_points5__png, false, 16, 16);
		}
		else if (_type == PickUpTypes.Health)
		{
			loadGraphic(AssetPaths.pickup_Health__png, false, 16, 16);
		}
		else if (_type == PickUpTypes.PowerUpShootDamage)
		{
			loadGraphic(AssetPaths.pickup_Shots_Damage__png, false, 16, 16);
		}
		else if (_type == PickUpTypes.PowerUpShootFrequency)
		{
			loadGraphic(AssetPaths.pickup_Shots_Speed__png, false, 16, 16);
		}
	}
	
	public override function kill () : Void
	{
		alive = false;
		FlxTween.tween(scale, { x: 5.0, y:5.0 }, 0.5, { complete:function(t:FlxTween):Void { exists = false; }} );
		FlxTween.tween(this, { alpha:0.0 }, 0.4 );
	}
}