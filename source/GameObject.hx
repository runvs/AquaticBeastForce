package;
import flixel.FlxObject;
import flixel.tweens.FlxTween;
import flixel.util.FlxColorUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxVector;
import flixel.FlxSprite;

/**
 * ...
 * @author Thunraz
 */
class GameObject extends FlxObject
{
    public var sprite:FlxSprite;
    public var name:String;
    
    /*
     * Who hit this object the last time?
     * -1 enemy
     *  1 player 1,
     *  2 player 2
     */
    private var _lastHit:Int;
    private var _scale:FlxVector;
    private var _health:Float;
    private var _healthMax:Float;
    private var _spawnedPickUp:Bool;
    private var _state:PlayState;

    private var _shadowSprite:FlxSprite;
    private var _shadowDistance:Float;
    

    public function new(X:Float=0, Y:Float=0)
    {
        if (_scale == null)
        {
            _scale = new FlxVector(16, 16);
        }
        
        super(X, Y);
    }

    public override function kill():Void
    {
        if (alive && exists)
        {
            /*
             * We need to call super.kill first, otherwise the GameObject
             * could get damaged by its own explosion
             * and cause an endless loop
             */
            super.kill();
            _state.addExplosion( new Explosion(x + Std.int(_scale.x - 16) / 2, y + Std.int(_scale.y - 16) / 2, false, true) );
        }
    }
    
    public function getScale():FlxVector
    {
        return _scale;
    }
    
    public function getLastHit():Int
    {
        return _lastHit;
    }

    public function setLastHit(playerNumber:Int):Void
    {
        _lastHit = playerNumber;
    }
    
    private function spawnPickUp():Void
    {
        if (!_spawnedPickUp)
        {
            if (FlxRandom.float() < GameProperties.PickUpDropChance)
            {
                var p:PickUp = new PickUp(new FlxPoint(x, y));
                _state.addPickUp(p);
            }
            _spawnedPickUp = true;
        }
    }
    
    private function flashSprite():Void
    {
        var black:Int = FlxColorUtil.makeFromARGB(1.0,   0,   0,   0);
        var white:Int = FlxColorUtil.makeFromARGB(1.0, 255, 255, 255);
        
        sprite.color = black;
        FlxTween.color(sprite, 0.1, black, white);
    }

    public function takeDamage(damage:Float):Void
    {
        if (alive && exists)
        {
            _health -= damage;
            flashSprite();
            checkDead();
        }
    }
    
    private function checkDead():Void { }
}