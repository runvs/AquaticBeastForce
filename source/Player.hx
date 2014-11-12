package ;
import flixel.FlxObject;
import flixel.FlxSprite;
import flash.display.BlendMode;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import lime.math.Vector2;

/**
 * ...
 * @author Thunraz
 */
class Player extends FlxObject
{
    public var _sprite:FlxSprite;
    private var _shadowSprite:FlxSprite;
    private var _state:PlayState;    
	
	
	
	private var _health:Float;
	private var _healthMax:Float;
	
	private var _remainingLives:Int;
	
	private var _respawnPosition:FlxPoint;
	
	private var _weaponSystems:WeaponSystems;
	
	public var _mgfireTime:Float;
	public var _specialWeaponFireTime:Float;
	public var _dead:Bool;
	
	public function new(state:PlayState)
	{   

		_dead = false;
		_weaponSystems = new WeaponSystems();
		
		// for testing
		_weaponSystems._hasAirGroundRockets = true;
		
		FlxG.stage.quality = flash.display.StageQuality.BEST;
		_state = state;
        // Load sprite for the player
        _sprite = new FlxSprite();
		trace(AssetPaths.player__png);
        _sprite.loadGraphic(AssetPaths.player__png, true, 16, 16);
        _sprite.animation.add("base", [0, 1, 2, 3], 12, true);
        _sprite.animation.play("base");
        
		// Load sprite for the shadow
        _shadowSprite = new FlxSprite();
        _shadowSprite.loadGraphic(AssetPaths.playerShadow__png, true, 16, 16);
        _shadowSprite.animation.add("base", [0, 1], 12, true);
        _shadowSprite.animation.play("base");
        _shadowSprite.alpha = 0.75;
        _shadowSprite.blend = BlendMode.MULTIPLY;
		
		_health = _healthMax = GameProperties.PlayerHealthDefault;
		_remainingLives = GameProperties.PlayerLivesDefault;
		
		
		_mgfireTime = 0;
		_specialWeaponFireTime = 0;
        
        super();
	}
	

    override public function update():Void 
    {
        getInput();
        
        _sprite.setPosition(x, y);
        _sprite.angle = angle;
        _sprite.update();
        
        _shadowSprite.setPosition(x + 3, y + 3);
        _shadowSprite.angle = angle;
        _shadowSprite.update();
        
        velocity.x *= 0.98;
        velocity.y *= 0.98;
		
		_mgfireTime += FlxG.elapsed;
		_specialWeaponFireTime += FlxG.elapsed;
		
		
        super.update();
    }
    
    override public function draw():Void 
    {
        _shadowSprite.draw();
        _sprite.draw();
        
        super.draw();
    }
	
	public function drawHud():Void
	{
		
	}
	
    
    private function getInput():Void
    {
        var up:Bool = FlxG.keys.anyPressed(["W", "UP"]);
        var down:Bool = FlxG.keys.anyPressed(["S", "DOWN"]);
        var left:Bool = FlxG.keys.anyPressed(["A", "LEFT"]);
        var right:Bool = FlxG.keys.anyPressed(["D", "RIGHT"]);
		var shot:Bool = FlxG.keys.anyPressed(["Space","X"]);
        
        if (!(left && right))
        {
            if (left)
            {
                angle = (angle - GameProperties.PlayerRotationSpeed) % 360;
            }
            else if (right)
            {
                angle = (angle + GameProperties.PlayerRotationSpeed) % 360;
            }
        }
        
        if (!(up && down))
        {
            if (up)
            {
                move(GameProperties.PlayerMovementSpeed * FlxG.elapsed);
            }
            else if (down)
            {
                move(-GameProperties.PlayerMovementSpeed * FlxG.elapsed);
            }
        }
		
		if (shot)
		{
			if (_mgfireTime >= _weaponSystems._mgFireTimeMax)
			{
				shoot();
			}
			if (_specialWeaponFireTime > _weaponSystems._specialWeaponFireTimeMax)
			{
				shootSpecial();
			}
		
		}
    }
    
    private function move(distance:Float):Void
    {
		var rad:Float = angle / 180 * Math.PI;
        var dx:Float = Math.cos(rad) * distance;
        var dy:Float = Math.sin(rad) * distance;
        
        velocity.x += dx;
        velocity.y += dy;
    }
	
	private function shootSpecial():Void
	{
		_specialWeaponFireTime = 0;
		if (_weaponSystems._hasAirGroundRockets)
		{
			//trace ("Player Shooting");
			//var dangle = FlxRandom.floatRanged( -GameProperties.PlayerWeaponMgSpreadInDegree, GameProperties.PlayerWeaponMgSpreadInDegree);
			var rad:Float = (angle) / 180 * Math.PI;
			var dx:Float = Math.cos(rad) * 7 + 5;
			var dy:Float = Math.sin(rad) * 7 + 7;
			//trace ("Shot created");

			var s:Shot = new Shot(x + dx, y + dy, angle , ShotType.Rocket, _state);
			_state.addShot(s);
		}
		else if (_weaponSystems._hasAirAirRockets)
		{
			
		}
		else if (_weaponSystems._hasAutoTurret)
		{
			
		}
		else if (_weaponSystems._hasLaser)
		{
			
		}
	}
	
	
	private function shoot():Void
	{
		//trace ("Player Shooting");
		var dangle = FlxRandom.floatRanged( -GameProperties.PlayerWeaponMgSpreadInDegree, GameProperties.PlayerWeaponMgSpreadInDegree);
		var rad:Float = (angle) / 180 * Math.PI;
		var dx:Float = Math.cos(rad) * 7 + 5;
        var dy:Float = Math.sin(rad) * 7 + 7;
		//trace ("Shot created");

		var s:Shot = new Shot(x + dx, y + dy, angle + dangle, ShotType.Mg, _state);
		_state.addShot(s);

		//trace ("Shot created");
		_mgfireTime = 0;
	}
	
	public function repair():Void
	{
		_health = _healthMax;
	}
	
	
	public function takeDamage(damage:Float):Void
	{
		FlxG.camera.shake(0.005,0.25);
		FlxG.camera.flash(FlxColor.RED, 0.25);
		_health -=  damage;
		checkDead();
		
	}
	
	
	private function checkDead()
	{
		if (_health <= 0)
		{
			die();
		}
	}
	
	private function die():Void
	{
		alive = false;
		// start Die animation
		
		FlxG.camera.fade(FlxColor.BLACK, 1, false, endThisLife);
	}
	
	public function endThisLife():Void
	{
		_remainingLives = _remainingLives - 1;
		if (_remainingLives >= 0)
		{
			respawn();
		}
		else 
		{
			_dead = true;
		}
	}
	
	
	private function respawn():Void
	{
		alive = true;
		FlxG.camera.fade(FlxColor.BLACK, 1, true);
		x = _respawnPosition.x;
		y = _respawnPosition.y;
	}
	
	public function setRespawnPosition(pos:FlxPoint, moveToPosition:Bool = false):Void
	{
		_respawnPosition = pos;
		if (moveToPosition)
		{
			respawn();
		}
	}
	
	
}