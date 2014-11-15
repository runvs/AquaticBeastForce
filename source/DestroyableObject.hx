package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxTimer;
import haxe.ds.StringMap;

/**
 * ...
 * @author 
 */
class DestroyableObject extends FlxObject
{
    public var sprite:FlxSprite;
    public var name:String;
    
    private var _type:String;
    private var _health:Float;
    private var _state:PlayState;
    
    static private function GetHitpoints(type:String):Float
    {
        if (type == "barrel")
        {
            return 5;
        }
		else if (type == "fueltank")
        {
            return 25;
        }
        else
        {
            return 1;
        }
    }

    static private function GetScale(type:String):Int
    {
        if (type == "barrel")
        {
            return 8;
        }
		else if (type == "fueltank")
        {
            return 24;
        }
        else
        {
            return 16;
        }
    }
	
	static private function GetSize(type:String):Int
    {
        if (type == "barrel")
        {
            return 16;
        }
		else if (type == "fueltank")
        {
            return 24;
        }
        else
        {
            return 16;
        }
    }

    public function new(X:Float=0, Y:Float=0, type:String, state:PlayState) 
    {
        _type = type;
        _state = state;
        
        var imagepath:String = "assets/images/" + type + ".png";
        //trace ("destoyable constructor: " + imagepath);
        sprite = new FlxSprite();
        sprite.loadGraphic(imagepath, true, GetSize(_type), GetSize(_type));
        sprite.setGraphicSize(GetScale(_type), GetScale(_type));
        sprite.updateHitbox();
        sprite.animation.add("normal", [0], 30, true);
        sprite.animation.add("destroyed", [1],30,true);
        sprite.animation.play("normal");
        
        _health = GetHitpoints(_type);
        
        
        super(X, Y);
        
    }

    public function takeDamage(damage:Float):Void
    {
        if (alive && exists)
        {
            _health -=  damage;
            //trace ("remaining health " + _health);
            checkDead();
        }
    }

    private function checkDead()
    {
        if (_health <= 0)
        {
            kill();
        }
    }

    public override function kill():Void
    {
        if (alive && exists)
        {
            alive = false;
            
            _state.addExplosion(new Explosion(x + (GetScale(_type)-16)/2, y + (GetScale(_type) - 16)/2));	// probably just a small explosion?
            var t: FlxTimer = new FlxTimer(0.2, switchImage);	// this timer is needed so the image is flipped after the explosion has started. Fancy juicy shit :D
        }
        
    }

    public function switchImage(t:FlxTimer):Void
    {
		trace ("switch image");
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
        super.update();
    }


}