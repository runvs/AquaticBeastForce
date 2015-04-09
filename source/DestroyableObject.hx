package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxColorUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;
import flixel.util.FlxVector;
import haxe.ds.StringMap;

/**
 * ...
 * @author
 */
class DestroyableObject extends FlxObject
{
    public var sprite:FlxSprite;
    public var name:String;

    public var _type:String;

	private var _lastHit:Int; 	// -1 enemy, 1 p1, 2 p2

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
        var scale:FlxVector = GetScale(_type);

        sprite = new FlxSprite();
        sprite.loadGraphic(imagepath, true, Std.int(size.x), Std.int(size.y));
        sprite.setGraphicSize(Std.int(scale.x), Std.int(scale.y));
        sprite.updateHitbox();

        addAnimations();
        sprite.animation.play("normal");

        _health = GetHitpoints(_type);

        super(X, Y);
    }

    public function takeDamage(damage:Float):Void
    {
        if (alive && exists)
        {
            _health -= damage;
			FlashSprite();
            checkDead();
        }
    }

    public function getLastHit () : Int
    {
        return _lastHit;
    }

	public function setLastHit ( playerNumber : Int ) : Void
	{
		_lastHit = playerNumber;
	}

    public function switchImage(t:FlxTimer):Void
    {
        sprite.animation.play("destroyed");
    }

	public function FlashSprite () :Void
	{
		sprite.color = FlxColorUtil.makeFromARGB(1.0, 0, 0, 0);
		FlxTween.color(sprite, 0.1,  FlxColorUtil.makeFromARGB(1.0, 0, 0, 0),  FlxColorUtil.makeFromARGB(1.0, 255, 255, 255));
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