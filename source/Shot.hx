package ;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flash.display.BlendMode;
/**
 * ...
 * @author ...
 */
class Shot extends FlxObject
{
	private var _sprite:FlxSprite;
	private var _type:ShotType;
	
	public function new(X:Float=0, Y:Float=0, Angle:Float=0, type:ShotType) 
	{
		super(X, Y);
		angle = Angle;
		_type = type;
		_sprite = new FlxSprite();
		
		var rad:Float = angle / 180 * Math.PI;
        var dx:Float = Math.cos(rad);
        var dy:Float = Math.sin(rad);
		
		if (_type == ShotType.Mg)
		{
			trace ("create MG shot");
			velocity.x = dx * GameProperties.ShotMGMovementSpeed;
			velocity.y = dy * GameProperties.ShotMGMovementSpeed;
			_sprite.loadGraphic(AssetPaths.shot_mg__png, false, 8, 1);
			_sprite.alpha = 0.5;
			_sprite.blend = BlendMode.ALPHA;
			_sprite.angle = angle;
			
		}
		else if (_type == ShotType.MgSmall)
		{
			trace ("create MGSmall shot");
			_sprite.loadGraphic(AssetPaths.shot_mg__png, false, 8, 1);
			_sprite.alpha = 0.25;
			_sprite.blend = BlendMode.ALPHA;
			_sprite.setGraphicSize(4, 1);
			_sprite.updateHitbox();
		}
		else if (_type == ShotType.Rocket)
		{
		}
		else if (_type == ShotType.Laser)
		{
			
		}
		else
		{
			throw "ERROR: cannot determine shot type";
		}
		
		trace ("Shot constuctor finished");
		
	}
	
	
	public override function update():Void
	{
		super.update();
		if (_type == ShotType.Mg || _type == ShotType.MgSmall)
		{
			updateMG();
		}
		else if (_type == ShotType.Rocket)
		{
			updateRocket();
		}
		else if (_type == ShotType.Laser)
		{
			updateLaser();
		}
	}
	
	private function updateMG():Void
	{
		
		//_sprite.angle = angle; // angle does not change here
		_sprite.setPosition(x, y);
	}
	private function updateRocket():Void
	{
		_sprite.angle = angle;
		_sprite.setPosition(x, y);
	}
	private function updateLaser():Void
	{
		throw "Not Implemented";
	}
	
	public override function draw():Void
	{
		super.draw();
		_sprite.draw();
	}
}