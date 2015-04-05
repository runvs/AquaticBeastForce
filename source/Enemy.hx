package ;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.util.FlxColorUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import flixel.util.FlxVector;
using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Thunraz
 */
class Enemy extends FlxObject
{
    public var type:EnemyType;
    public var name:String;
    public var isGround:Bool;
    public var sprite:FlxSprite;


    private var _shadowSprite:FlxSprite;
    private var _shadowDistance:Float;
    private var _state:PlayState;

    private var _health:Float;
    private var _healthMax:Float;

    private var _shootTimer:Float;
    private var _shootTimerMax:Float;
	private var _hasSeenPlayer:Bool;
	private var _spawnedPickUp:Bool;
	
	private var _lastHit : Int;		// -1 enemy, 1 p1, 2 p2;
	
    public function new()
    {
		_hasSeenPlayer = false;
		_spawnedPickUp = false;
		_lastHit = -1;
        super();
    }

    override public function update():Void 
    {
        sprite.setPosition(x, y);
        _shadowSprite.setPosition(x + _shadowDistance, y + _shadowDistance);
        
        sprite.angle = angle;
        _shadowSprite.angle = angle;
        
        sprite.update();
        _shadowSprite.update();
        
        velocity.x *= 0.96;
        velocity.y *= 0.96;
        
        super.update();
    }

    public function shoot():Void
    {
        if (_shootTimer >= _shootTimerMax)
        {
            var dAngle = FlxRandom.floatRanged(-GameProperties.PlayerWeaponMgSpreadInDegree, GameProperties.PlayerWeaponMgSpreadInDegree);
            var rad:Float = (angle) / 180 * Math.PI;
            var dx:Float = Math.cos(rad) * 7 + 5;
            var dy:Float = Math.sin(rad) * 7 + 7;
            
            var s:Shot = new Shot(x + dx, y + dy, angle + dAngle, ShotType.Mg, _state, -1);
			s.setDamage(1, 1);
            _state.addShot(s);
            
            _shootTimer = 0;
        }
    }

    public function takeDamage(damage:Float):Void
    {
        if (alive && exists)
        {
            _health -=  damage;
			FlashSprite();
            checkDead();
			_hasSeenPlayer = true;
			
        }
    }
	public function setLastHit ( playerNumber : Int ) : Void
	{
		_lastHit = playerNumber;
	}

    private function checkDead()
    {
        if (alive && exists)
        {
            if (_health <= 0)
            {
                Analytics.LogEnemyDestroyed(this);
                kill();
				SpawnPickUp();
				
				_state.addPoints(FlxRandom.intRanged(3, 6), _lastHit);
            }
        }
    }

    public function getLastHit () : Int 
    {
        return _lastHit;
    }
    
	private function SpawnPickUp() : Void 
	{
		if (!_spawnedPickUp)
		{
			if (FlxRandom.float() < GameProperties.PickUpDropChance)
			{
				var p : PickUp = new PickUp(new FlxPoint(x, y));
				_state.addPickUp(p);
			}
			_spawnedPickUp = true;
		}
	}
	
    override public function draw():Void 
    {
        _shadowSprite.draw();
        sprite.draw();
        super.draw();
    }
	
	public function FlashSprite () :Void
	{
		sprite.color = FlxColorUtil.makeFromARGB(1.0, 0, 0, 0);
		FlxTween.color(sprite, 0.1,  FlxColorUtil.makeFromARGB(1.0, 0, 0, 0),  FlxColorUtil.makeFromARGB(1.0, 255, 255, 255));
	}
	

    public override function kill():Void
    {
        super.kill();
        // we need to call kill first, otherwise the enemy could get damaged by its own explosion and cause an endless loop
        _state.addExplosion(new Explosion(x , y, false , true ));
    }
	
	public function UnseePlayer():Void
	{
		_hasSeenPlayer = false;
	}
}