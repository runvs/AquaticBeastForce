package;

import flixel.util.FlxVector;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.util.FlxRandom;

/**
 * ...
 * @author
 */
class DestroyableObject extends GameObject
{
    public var _type:DestroyableType;

    public function new(X:Float=0, Y:Float=0, type:DestroyableType, state:PlayState)
    {
        _type = type;
        _state = state;
        _lastHit = -1;

        super(X, Y);
    }

    public override function kill():Void
    {
        super.kill();

        if (alive && exists)
        {
            /*
             * Flip the image using a timer
             * after the explosion has started.
             * Fancy juicy shit :D
             */           
            var t: FlxTimer = new FlxTimer(0.2, switchImage);
        }
    }
    
    private override function checkDead():Void
    {
        if (_health <= 0)
        {
            Analytics.LogDestroyableDestroyed(this);
            kill();
            _state.addPoints(FlxRandom.intRanged(1, 3), _lastHit);
        }
    }

    public function switchImage(t:FlxTimer):Void
    {
        sprite.animation.play("destroyed");
    }


    override public function draw():Void
    {
        super.draw();
        sprite.draw();
    }

    override public function update():Void
    {
        sprite.x = x;
        sprite.y = y;
        sprite.update();
        super.update();
    }


}