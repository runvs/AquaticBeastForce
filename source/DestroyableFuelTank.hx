package;
import flixel.FlxSprite;
import flixel.util.FlxVector;

/**
 * ...
 * @author Thunraz
 */
class DestroyableFuelTank extends DestroyableObject
{
    public function new(X:Float=0, Y:Float=0, state:PlayState, size:FlxVector, scale:FlxVector, health:Float)
    {
        _type = DestroyableType.FuelTank;
        _scale = scale;

        sprite = new FlxSprite();
        sprite.loadGraphic(AssetPaths.fueltank__png, true, Std.int(size.x), Std.int(size.y));
        sprite.setGraphicSize(Std.int(_scale.x), Std.int(_scale.y));
        sprite.updateHitbox();
        
        // Add "animations" and play the normal state
        sprite.animation.add("normal",    [0], 30, true);
        sprite.animation.add("destroyed", [1], 30, true);
        sprite.animation.play("normal");

        _health = health;
        
        super(X, Y, _type, state);
    }
}