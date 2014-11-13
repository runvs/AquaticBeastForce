package ;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxPoint;
import flash.display.BlendMode;

using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author ...
 */
class Shot extends FlxObject
{
	public var _sprite:FlxSprite;
	public var _type:ShotType;
	
	private var _state:PlayState;
	
	private var _lifetime:Float;
	
	public var _shooter:Bool;	// true if player, false if enemy
	
	private var _timer:Float;
	
	private var _damageBase:Float;
	private var _damageFactor:Float;
	
	public function setDamage(base:Float, factor:Float = 1.0):Void
	{
		_damageBase = base;
		_damageFactor = factor;
	}

	public function getDamage():Float
	{
		return _damageBase * _damageFactor;
	}
	
	public function new(X:Float=0, Y:Float=0, Angle:Float=0, type:ShotType, state:PlayState, playerShot:Bool = true ) 
	{
		super(X, Y);
		
		_shooter = playerShot;
		_state = state;
		_timer = 0;
		
		angle = Angle;
		_type = type;
		_sprite = new FlxSprite();
		
		var rad:Float = angle / 180 * Math.PI;
        var dx:Float = Math.cos(rad);
        var dy:Float = Math.sin(rad);
		
		if (_type == ShotType.Mg)
		{
			velocity.x = dx * GameProperties.ShotMGMovementSpeed;
			velocity.y = dy * GameProperties.ShotMGMovementSpeed;
			_sprite.loadGraphic(AssetPaths.shot_mg__png, false, 8, 1);
			_sprite.alpha = 0.5;
			_sprite.angle = angle;
			_lifetime = GameProperties.ShotMGLifeTime;
			
		}
		else if (_type == ShotType.MgSmall)
		{
			velocity.x = dx * GameProperties.ShotMGMovementSpeed;
			velocity.y = dy * GameProperties.ShotMGMovementSpeed;
			_sprite.loadGraphic(AssetPaths.shot_mg__png, false, 8, 1);
			_sprite.alpha = 0.25;
			_sprite.setGraphicSize(4, 1);
			_sprite.updateHitbox();
			_sprite.angle = angle;
			_lifetime = GameProperties.ShotMGSmallLifeTime;
		}
		else if (_type == ShotType.RocketAirGround)
		{
			velocity.x = dx * GameProperties.ShotRocketMoveSpeedInitial;
			velocity.y = dy * GameProperties.ShotRocketMoveSpeedInitial;
			_sprite.loadGraphic(AssetPaths.shot_rocket_ground__png, false, 16, 9);
			_sprite.setGraphicSize(8, 4);
			_sprite.alpha = 1.0;
			_sprite.angle = angle;
			
			_lifetime = GameProperties.ShotRocketLifeTime;
		}
		else if (_type == ShotType.RocketAirAir)
		{
			velocity.x = dx * GameProperties.ShotRocketMoveSpeedInitial;
			velocity.y = dy * GameProperties.ShotRocketMoveSpeedInitial;
			_sprite.loadGraphic(AssetPaths.shot_rocket__png, false, 8, 1);
			_sprite.alpha = 1.0;
			_sprite.angle = angle;
			
			_lifetime = GameProperties.ShotRocketLifeTime;
		}
		else if (_type == ShotType.Ballistic)
		{
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
		else if (_type == ShotType.BFG)
		{
			velocity.x = dx * GameProperties.ShotBFGMovementSpeed;
			velocity.y = dy * GameProperties.ShotBFGMovementSpeed;
			_sprite.loadGraphic(AssetPaths.shot_bfg__png, true, 8, 8);
			_sprite.setGraphicSize(4, 4);
			_sprite.animation.add("normal", [0, 1, 2], 30, true);
			_sprite.animation.play("normal");
			_sprite.alpha = 1.0;
			_sprite.angle = angle;
			_sprite.angularVelocity = 10;
			_lifetime = GameProperties.ShotBFGLifeTime;
		}
		else
		{
			throw "ERROR: cannot determine shot type";
		}
		
		width = _sprite.width;
		height = _sprite.height;
	}
	
	
	public override function update():Void
	{
		super.update();
		_sprite.update();
		
		_lifetime -= FlxG.elapsed;
		_timer += FlxG.elapsed;
		
		if (_type == ShotType.Mg || _type == ShotType.MgSmall)
		{
			updateMG();
		}
		else if (_type == ShotType.RocketAirAir || _type == ShotType.RocketAirGround)
		{
			updateRocket();
		}
		else if (_type == ShotType.Laser)
		{
			updateLaser();
		}
		else if (_type == ShotType.BFG)
		{
			updateBFG();
		}
		if (_lifetime <= 0)
		{
			kill();
		}
		
	}
	
	private function updateBFG():Void
	{
		_sprite.setPosition(x, y);
		
	}
	
	private function updateMG():Void
	{
		
		//_sprite.angle = angle; // angle does not change here
		_sprite.setPosition(x, y);
	}
	private function updateRocket():Void
	{

		var VelocitySpeedUp:Float = 80;
		var velo:Float = _timer * VelocitySpeedUp + GameProperties.ShotRocketMoveSpeedInitial;
		var maxVelocity:Float = 150;
		velo = (velo < maxVelocity) ? velo : maxVelocity;
		var rad:Float = angle / 180 * Math.PI;
        var dx:Float = Math.cos(rad);
        var dy:Float = Math.sin(rad);
		//trace(velo);
		velocity.x = dx * velo;
		velocity.y = dy * velo;
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
	
	public override function kill():Void
	{
		if (_type == ShotType.RocketAirAir || _type == ShotType.RocketAirGround)
		{
			var e:Explosion = new Explosion(x, y);
			_state.addExplosion(e);
			deleteObject();
		}
		else
		{
			_sprite.fadeOut(0.5, false, finalKill);
		}
	}
	
	public function deleteObject():Void
	{
		alive = false;
		exists = false;
	}
	
	public function finalKill(t:FlxTween ):Void
	{
		deleteObject();
	}
	
}