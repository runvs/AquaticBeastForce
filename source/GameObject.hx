package;
import flixel.util.FlxVector;

/**
 * ...
 * @author Thunraz
 */
class GameObject extends FlxObject
{
    private var _scale:FlxVector;

    private var _health:Float;
    private var _healthMax:Float;

    private var _state:PlayState;

    public function new()
    {

    }

    public override function kill():Void
    {
        /*
         * We need to call kill first, otherwise the GameObject
         * could get damaged by its own explosion
         * and cause an endless loop
         */

        if (alive && exists)
        {
            super.kill();
            _state.addExplosion( new Explosion(x + Std.int(_scale.x - 16) / 2, y + Std.int(_scale.y - 16) / 2, false, true) );
        }
    }

}