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
    public var _type:String;

    static private function GetHitpoints(type:String):Float
    {
        switch(type)
        {
            case "barrel":
                return 5;
            case "fueltank":
                return 25;
            case "radar":
                return 10;
            case "tent":
                return 8;
            case "tower":
                return 12;
            default:
                return 1;
        }
    }

    static public function GetScale(type:String):FlxVector
    {
        switch(type)
        {
            case "barrel":
                return new FlxVector(8, 8);
            case "fueltank":
                return new FlxVector(24, 24);
            case "tent":
                return new FlxVector(32, 16);
            default:
                return new FlxVector(16, 16);
        }
    }

    static private function GetSize(type:String):FlxVector
    {
        switch(type)
        {
            case "barrel":
                return new FlxVector(16, 16);
            case "fueltank":
                return new FlxVector(24, 24);
            case "tent":
                return new FlxVector(32, 16);
            default:
                return new FlxVector(16, 16);
        }
    }

    override public function kill():Void
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

    private function addAnimations():Void
    {
        switch(_type)
        {
            case "radar":
                sprite.animation.add("normal", [0, 1, 2, 3, 4, 5, 6, 7], 8, true);
                sprite.animation.add("destroyed", [8], 30, true);
            default:
                sprite.animation.add("normal", [0], 30, true);
                sprite.animation.add("destroyed", [1],30,true);
        }
    }

    public function new(X:Float=0, Y:Float=0, type:String, state:PlayState)
    {
        _type = type;
        _state = state;
        _lastHit = -1;

        var imagepath:String = "assets/images/" + _type + ".png";
        var size:FlxVector = GetSize(_type);
        _scale = GetScale(_type);

        sprite = new FlxSprite();
        sprite.loadGraphic(imagepath, true, Std.int(size.x), Std.int(size.y));
        sprite.setGraphicSize(Std.int(_scale.x), Std.int(_scale.y));
        sprite.updateHitbox();

        addAnimations();
        sprite.animation.play("normal");

        _health = GetHitpoints(_type);

        super(X, Y);
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