package ;

import flixel.FlxBasic;
import flixel.FlxG;
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
	public var _sprite:FlxSprite;
	private var _type:ShotType;
	
	private var _state:PlayState;
	
	private var _lifetime:Float;
	
	
	public function new(X:Float=0, Y:Float=0, Angle:Float=0, type:ShotType, state:PlayState) 
	{
		super(X, Y);
		
		_state = state;
		
		
		angle = Angle;
		_type = type;
		_sprite = new FlxSprite();
		
		var rad:Float = angle / 180 * Math.PI;
        var dx:Float = Math.cos(rad);
        var dy:Float = Math.sin(rad);
		
		if (_type == ShotType.Mg)
		{
			//trace ("create MG shot");
			velocity.x = dx * GameProperties.ShotMGMovementSpeed;
			velocity.y = dy * GameProperties.ShotMGMovementSpeed;
			_sprite.loadGraphic(AssetPaths.shot_mg__png, false, 8, 1);
			_sprite.alpha = 0.5;
			_sprite.blend = BlendMode.ALPHA;
			_sprite.angle = angle;
			_lifetime = GameProperties.ShotMGLifeTime;
			
		}
		else if (_type == ShotType.MgSmall)
		{
			//trace ("create MGSmall shot");
			_sprite.loadGraphic(AssetPaths.shot_mg__png, false, 8, 1);
			_sprite.alpha = 0.25;
			_sprite.blend = BlendMode.ALPHA;
			_sprite.setGraphicSize(4, 1);
			_sprite.updateHitbox();
			_lifetime = GameProperties.ShotMGSmallLifeTime;
		}
		else if (_type == ShotType.Rocket)
		{
			//trace ("create Roeckt shot");
			velocity.x = dx * GameProperties.ShotMGMovementSpeed;
			velocity.y = dy * GameProperties.ShotMGMovementSpeed;
			_sprite.loadGraphic(AssetPaths.shot_mg__png, false, 8, 1);
			_sprite.alpha = 1.0;
			_sprite.angle = angle;
			
			_lifetime = GameProperties.ShotRocketLifeTime;
		}
		else if (_type == ShotType.Laser)
		{
			
		}
		else
		{
			throw "ERROR: cannot determine shot type";
		}
		
		//trace ("Shot constuctor finished");
		
	}
	
	
	public override function update():Void
	{
		super.update();
		
		_lifetime -= FlxG.elapsed;
		
		
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
		
		if (_lifetime <= 0)
		{
			kill();
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
		if (alive && exists)
		{
			super.draw();
			_sprite.draw();
		}
	}
	
	//public override function kill():Void
	//{
		//if (_type == ShotType.Rocket)
		//{
			//var e:Explosion = new Explosion(x, y);
			//_state.AddExplosion(e);
		//}
		//alive = false;
		//exists = false;
	//}
	
}