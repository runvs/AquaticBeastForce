package ;
import flixel.FlxObject;
import flixel.FlxSprite;
import flash.display.BlendMode;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxColorUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxVector;
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
	
	
	
	public var _health:Float;
	public var _healthMax:Float;
	
	private var _remainingLives:Int;
	
	private var _respawnPosition:FlxPoint;
	
	public var _weaponSystems:WeaponSystems;
	
	public var _mgfireTime:Float;
	public var _specialWeaponFireTime:Float;
	public var _dead:Bool;
	
	private var _locator:FlxSprite;
	
	private var _hud:FlxSprite;
	private var _hudHealthBar:FlxSprite;
    private var _hudBackground:FlxSprite;
	
	private var _currentPoints:Int = 0;
    public static var TotalPoints:Int = 0;
	
	public function new(state:PlayState)
	{   
		_dead = false;
		_weaponSystems = new WeaponSystems();
		
		// for testing
		_weaponSystems._hasAutoTurret = false;
		
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
		
		_locator = new FlxSprite();
		_locator.loadGraphic(AssetPaths.locator__png, true, 16, 16);
		_locator.animation.add("base", [0, 1, 2, 3, 4, 5], 5, true);
		_locator.alpha = 0.5;
		_locator.setGraphicSize(8, 8);
		_locator.updateHitbox();
		_locator.animation.play("base");
		
		_hud = new FlxSprite();
		_hud.loadGraphic(AssetPaths.hud__png);
		_hud.x = 0;
		_hud.y = 128;
		_hud.scrollFactor.set(0,0);
		
		_hudHealthBar = new FlxSprite();
		_hudHealthBar.loadGraphic(AssetPaths.hud_health__png);
		_hudHealthBar.x = 76;
		_hudHealthBar.y = _hud.y + 6;
		_hudHealthBar.scrollFactor.set(0, 0);
		_hudHealthBar.origin.set(0, 0);
        
        _hudBackground = new FlxSprite();
        _hudBackground.loadGraphic(AssetPaths.hud_background__png);
		_hudBackground.x = 0;
		_hudBackground.y = 128;
		_hudBackground.scrollFactor.set(0,0);
		
		_health = _healthMax = GameProperties.PlayerHealthDefault;
		_remainingLives = GameProperties.PlayerLivesDefault;
		
		_mgfireTime = 0;
		_specialWeaponFireTime = 0;
		
		_currentPoints = 100;
        
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
		
		_locator.update();
        
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
        _hudBackground.draw();
		
		var factor:Float = _health / _healthMax;
        if (factor < 0)
        {
            factor = 0.0;
        }
        
        _hudHealthBar.x = 77 + factor * _hudHealthBar.width;
		_hudHealthBar.draw();
        
		_hud.draw();
	}
	
	// pass the target's center position
	public function drawLocator(targetX:Float, targetY:Float):Void
	{
		// take into account that the players position is on its top left corner (so the -8 offset to get to the sprite's center)
		var direction:FlxVector = new FlxVector(targetX - x - 8, targetY - y - 8);

		_locator.angle = direction.degrees;
		var l:Float = direction.length;
		direction.normalize();
		var distanceScale = (l < 100) ? l * 0.5  : 50;
		_locator.x = x + direction.x * distanceScale + 4;
		_locator.y = y + direction.y * distanceScale + 4;
		if (direction.y * distanceScale + 4 > 120) 
		{
			_locator.y  = 120 + y;
		}
		_locator.draw();
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
		if (_weaponSystems._hasAutoTurret)
		{
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
			//var dangle = FlxRandom.floatRanged( -GameProperties.PlayerWeaponMgSpreadInDegree, GameProperties.PlayerWeaponMgSpreadInDegree);
			var rad:Float = (angle) / 180 * Math.PI;
			var dx:Float = Math.cos(rad) * 7 + 5;
			var dy:Float = Math.sin(rad) * 7 + 7;

			var s:Shot = new Shot(x + dx, y + dy, angle , ShotType.RocketAirGround, _state);
			s.setDamage(_weaponSystems._rocketAirGroundDamageBase, _weaponSystems._rocketAirGroundDamageFactor);
			_state.addShot(s);
		}
		else if (_weaponSystems._hasAirAirRockets)
		{
			//var dangle = FlxRandom.floatRanged( -GameProperties.PlayerWeaponMgSpreadInDegree, GameProperties.PlayerWeaponMgSpreadInDegree);
			var rad:Float = (angle) / 180 * Math.PI;
			var dx:Float = Math.cos(rad) * 7 + 5;
			var dy:Float = Math.sin(rad) * 7 + 7;

			var s:Shot = new Shot(x + dx, y + dy, angle , ShotType.RocketAirAir, _state);
			s.setDamage(_weaponSystems._rocketAirAirDamageBase, _weaponSystems._rocketAirAirDamageFactor);
			_state.addShot(s);
		}
		else if (_weaponSystems._hasAutoTurret)
		{
			var e:Enemy = _state.getNearestEnemy();
			if (e == null)
			{
				return;
			}
			
			//var dangle = FlxRandom.floatRanged( -GameProperties.PlayerWeaponMgSpreadInDegree, GameProperties.PlayerWeaponMgSpreadInDegree);
			var dex:Float = e.x - x + 3;
			var dey:Float = e.y - y + 3;
			
			var rad:Float = (angle) / 180 * Math.PI;
			var dx:Float = Math.cos(rad) * 7 + 5;
			var dy:Float = Math.sin(rad) * 7 + 7;

			var tarAngle:Float = Math.atan2(dey, dex) * 180/Math.PI;
			//trace (dex + " " + dey + " " + tarAngle);
			var s:Shot = new Shot(x + dx, y + dy, tarAngle, ShotType.MgSmall, _state);
			s.setDamage(_weaponSystems._autoDamageBase, _weaponSystems._autoDamageFactor);
			_state.addShot(s);
		}
		else if (_weaponSystems._hasBFG)
		{
			var rad:Float = (angle) / 180 * Math.PI;
			var dx:Float = Math.cos(rad) * 7 + 5;
			var dy:Float = Math.sin(rad) * 7 + 7;

			var s:Shot = new Shot(x + dx, y + dy, angle , ShotType.BFG, _state);
			s.setDamage(_weaponSystems._bfgDamageBase, _weaponSystems._bfgDamageFactor);
			_state.addShot(s);
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
		s.setDamage(_weaponSystems._mgDamgeBase, _weaponSystems._mgDamageFactor);
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
		FlxG.camera.shake(0.005, 0.25);
		var col = FlxColorUtil.makeFromARGB(0.5, 255, 0, 0);
		FlxG.camera.flash(col, 0.25);
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
	
	public function SetMaxHealth ( newVal : Float) : Void 
	{
		_healthMax = newVal;
	}
	
	private function die():Void
	{
		if (alive)
		{
			alive = false;
			// start Die animation
			trace("die");
			//FlxG.camera.fade(FlxColor.BLACK, 1, false, endThisLife);
			endThisLife();
			_state.PlayerDead();
		}
	}
	
	public function endThisLife():Void
	{
		trace ("endlife");
		_remainingLives = _remainingLives - 1;
		if (_remainingLives >= 0)
		{
			trace ("remaining lives " + _remainingLives );
			respawn();
		}
		else 
		{
			_dead = true;
		}
	}
	
	private function respawn():Void
	{
		trace ("alive");
		_health = _healthMax;
		alive = true;
		//trace (FlxG.camera.color);
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
	
	public function AddPickUp ( p: PickUp ) : Void
	{
		if (p._type == PickUpTypes.Points1)
		{
			_currentPoints += 10;
			TotalPoints += 10;
		}
		else if (p._type == PickUpTypes.Points2)
		{
			_currentPoints += 20;
			TotalPoints += 20;
		}
		else if (p._type == PickUpTypes.Points5)
		{
			_currentPoints += 50;
			TotalPoints += 50;
		}
		else if (p._type == PickUpTypes.Health)
		{
			trace ("not implemented yet");
		}
		else if (p._type == PickUpTypes.PowerUpShootDamage)
		{
			trace ("not implemented yet");
		}
		else if (p._type == PickUpTypes.PowerUpShootFrequency)
		{
			trace ("not implemented yet");
		}
		else 
		{
			trace ("not implemented yet");
		}
	}
	
	public function HasEnoughPoints( p : Int) : Bool
	{
		return (_currentPoints >= p);
	}
	
	public function ChangePoints( diff: Int ) : Void 
	{
		if (diff > 0)
		{
			TotalPoints += diff;
			_currentPoints += diff;
		}
		else
		{
			_currentPoints += diff;
		}
	}
	
	
}