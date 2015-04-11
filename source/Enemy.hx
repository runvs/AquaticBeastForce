package;

import flixel.util.FlxRandom;

/**
 * ...
 * @author Thunraz
 */
class Enemy extends GameObject
{
    public var type:EnemyType;
    public var isGround:Bool;
    
    private var _shootTimer:Float;
    private var _shootTimerMax:Float;
    private var _hasSeenPlayer:Bool;

    public function new()
    {
        _hasSeenPlayer = false;
        _spawnedPickUp = false;
        _lastHit = -1;
        super();
    }

    public override function update():Void
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

    override public function draw():Void
    {
        _shadowSprite.draw();
        sprite.draw();
        super.draw();
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
    
    public override function takeDamage(damage:Float):Void 
    {
        if (alive && exists)
        {
            _hasSeenPlayer = true;
        }
        
        super.takeDamage(damage);
    }

    private override function checkDead():Void
    {
        if (alive && exists)
        {
            if (_health <= 0)
            {
                Analytics.LogEnemyDestroyed(this);
                kill();
                spawnPickUp();

                _state.addPoints(FlxRandom.intRanged(3, 6), _lastHit);
            }
        }
    }



    public function UnseePlayer():Void
    {
        _hasSeenPlayer = false;
    }
}