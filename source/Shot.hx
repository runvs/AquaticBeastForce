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
    public var sprite:FlxSprite;
    public var type:ShotType;
    public var isPlayer:Bool;

    private var _state:PlayState;

    private var _lifetime:Float;

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
		
		isPlayer = playerShot;
		_state = state;
		_timer = 0;
		
		angle = Angle;
		this.type = type;
		sprite = new FlxSprite();
		
		var rad:Float = angle / 180 * Math.PI;
        var dx:Float = Math.cos(rad);
        var dy:Float = Math.sin(rad);
		
		if (type == ShotType.Mg)
		{
			velocity.x = dx * GameProperties.ShotMGMovementSpeed;
			velocity.y = dy * GameProperties.ShotMGMovementSpeed;
			sprite.loadGraphic(AssetPaths.shot_mg__png, false, 8, 1);
			sprite.alpha = 0.5;
			sprite.angle = angle;
			_lifetime = GameProperties.ShotMGLifeTime;
			
		}
		else if (type == ShotType.MgSmall)
		{
			velocity.x = dx * GameProperties.ShotMGMovementSpeed;
			velocity.y = dy * GameProperties.ShotMGMovementSpeed;
			sprite.loadGraphic(AssetPaths.shot_mg__png, false, 8, 1);
			sprite.alpha = 0.5;
			sprite.setGraphicSize(4, 1);
			sprite.updateHitbox();
			sprite.angle = angle;
			_lifetime = GameProperties.ShotMGSmallLifeTime;
		}
		else if (type == ShotType.RocketAirGround)
		{
			velocity.x = dx * GameProperties.ShotRocketMoveSpeedInitial;
			velocity.y = dy * GameProperties.ShotRocketMoveSpeedInitial;
			sprite.loadGraphic(AssetPaths.shot_rocket_ground__png, false, 16, 9);
			sprite.setGraphicSize(8, 4);
			sprite.alpha = 1.0;
			sprite.angle = angle;
			
			_lifetime = GameProperties.ShotRocketLifeTime;
		}
		else if (type == ShotType.RocketAirAir)
		{
			velocity.x = dx * GameProperties.ShotRocketMoveSpeedInitial;
			velocity.y = dy * GameProperties.ShotRocketMoveSpeedInitial;
			sprite.loadGraphic(AssetPaths.shot_rocket__png, false, 8, 1);
			sprite.alpha = 1.0;
			sprite.angle = angle;
			
			_lifetime = GameProperties.ShotRocketLifeTime;
		}
		else if (type == ShotType.Ballistic)
		{
			velocity.x = dx * GameProperties.ShotBallisticMovementSpeed;
			velocity.y = dy * GameProperties.ShotBallisticMovementSpeed;
			sprite.loadGraphic(AssetPaths.shot_ballistic__png, false, 4, 4);
			sprite.alpha = 1.0;
			sprite.angle = angle;
			
			_lifetime = GameProperties.ShotBallisticLifeTime;
		}
		else if (type == ShotType.Laser)
		{
			
		}
		else if (type == ShotType.BFG)
		{
			velocity.x = dx * GameProperties.ShotBFGMovementSpeed;
			velocity.y = dy * GameProperties.ShotBFGMovementSpeed;
			sprite.loadGraphic(AssetPaths.shot_bfg__png, true, 8, 8);
			sprite.setGraphicSize(4, 4);
			sprite.animation.add("normal", [0, 1, 2], 30, true);
			sprite.animation.play("normal");
			sprite.alpha = 1.0;
			sprite.angle = angle;
			sprite.angularVelocity = 10;
			_lifetime = GameProperties.ShotBFGLifeTime;
		}
		else
		{
			throw "ERROR: cannot determine shot type";
		}
		
		width = sprite.width;
		height = sprite.height;
	}
	
	
	public override function update():Void
	{
		super.update();
		sprite.update();
		
		_lifetime -= FlxG.elapsed;
		_timer += FlxG.elapsed;
		
		if (type == ShotType.Mg || type == ShotType.MgSmall)
		{
			//trace ("update mgshot");
			updateMG();
		}
		else if (type == ShotType.RocketAirAir || type == ShotType.RocketAirGround)
		{
			updateRocket();
		}
		else if (type == ShotType.Laser)
		{
			updateLaser();
		}
		else if (type == ShotType.BFG)
		{
			updateBFG();
		}
		
		if (_lifetime <= 0)
		{
			//trace ("kill");
			kill();
		}
		
	}
	
	private function updateBFG():Void
	{
		sprite.setPosition(x, y);
		
	}
	
	private function updateMG():Void
	{
		//trace (x);
		//_sprite.angle = angle; // angle does not change here
		sprite.setPosition(x, y);
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
		sprite.angle = angle;
		sprite.setPosition(x, y);
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
			sprite.draw();
		}
	}
	
	public override function kill():Void
	{
		if (type == ShotType.RocketAirAir || type == ShotType.RocketAirGround)
		{
			var e:Explosion = new Explosion(x, y);
			_state.addExplosion(e);
			deleteObject();
		}
		else
		{
			sprite.fadeOut(0.5, false, finalKill);
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