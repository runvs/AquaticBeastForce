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
    private var _sprite:FlxSprite;
    private var _circle:Float;
    private var _velocity:FlxVector;
    
	public function new(x:Float, y:Float)
	{
		this.x = x;
        this.y = y;
        
        _circle = Math.PI * 2;
        
        _sprite = new FlxSprite(this.x, this.y);
        _sprite.loadGraphic(AssetPaths.player__png, true, 16, 16);
        
        _sprite.animation.add("base", [0, 1, 2, 3], 12, true);
        _sprite.animation.play("base");
        
        super();
	}
    
    override public function update():Void 
    {
        getInput();
        _sprite.setPosition(this.x, this.y);
        _sprite.angle = angle;
        _sprite.update();
        
        velocity.x *= 0.98;
        velocity.y *= 0.98;
		
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
        
        if (!(left && right))
        {
            if (left)
            {
                angle = (angle - GameProperties.PlayerRotationSpeed) % 360;
            }
            else if (right)
            {
                angle = (angle + GameProperties.PlayerRotationSpeed) % 360;
            }
        }
        
        if (!(up && down))
        {
            if (up)
            {
                move(GameProperties.PlayerMovementSpeed * FlxG.elapsed);
            }
            else if (down)
            {
                move(-GameProperties.PlayerMovementSpeed * FlxG.elapsed);
            }
        }
    }
    
    private function move(distance:Float):Void
    {
        var dx:Float = Math.cos(angle / 180 * Math.PI) * distance;
        var dy:Float = Math.sin(angle / 180 * Math.PI) * distance;
        
        velocity.x += dx;
        velocity.y += dy;
    }
}