package ;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxVector;
import flixel.util.FlxColor;

/**
 * ...
 * @author Thunraz
 */
class Player extends FlxObject
{
    public var position:FlxVector;
    public var rotation:Float;
    
    private var _sprite:FlxSprite;
    private var _circle:Float;
    
	public function new(x:Float, y:Float)
	{
		position = new FlxVector(x, y);
        
        _circle = Math.PI * 2;
        
        _sprite = new FlxSprite(position.x, position.y);
        _sprite.loadGraphic(AssetPaths.player__png, true, 16, 16);
        
        _sprite.animation.add("base", [0, 1, 2, 3], 12, true);
        _sprite.animation.play("base");
        
        super();
	}
    
    override public function update():Void 
    {
        getInput();
        _sprite.setPosition(position.x, position.y);
        _sprite.angle = rotation * 180/Math.PI;
        _sprite.update();
        
		this.x = position.x;
		this.y = position.y;
		
        super.update();
    }
    
    override public function draw():Void 
    {
        _sprite.draw();
        super.draw();
    }
    
    private function getInput():Void
    {
        var up:Bool = FlxG.keys.anyPressed(["W", "UP"]);
        var down:Bool = FlxG.keys.anyPressed(["S", "DOWN"]);
        var left:Bool = FlxG.keys.anyPressed(["A", "LEFT"]);
        var right:Bool = FlxG.keys.anyPressed(["D", "RIGHT"]);
        
        if (left)
        {
            rotation = (rotation - FlxG.elapsed * 5) % _circle;
        }
        else if (right)
        {
            rotation = (rotation + FlxG.elapsed * 5) % _circle;
        }
        
        if (up)
        {
            move(40 * FlxG.elapsed);
        }
        else if (down)
        {
            move(-40 * FlxG.elapsed);
        }
    }
    
    private function move(distance:Float):Void
    {
        var dx:Float = Math.cos(rotation + Math.PI * 3/2) * distance;
        var dy:Float = Math.sin(rotation + Math.PI * 3/2) * distance;
        
        position.x += dx;
        position.y += dy;
    }
}