package ;
import flixel.FlxObject;
import flixel.FlxSprite;
import flash.display.BlendMode;
import flixel.FlxG;

/**
 * ...
 * @author Thunraz
 */
class Player extends FlxObject
{
    private var _sprite:FlxSprite;
    private var _shadowSprite:FlxSprite;
        
	public function new()
	{   
        // Load sprite for the player
        _sprite = new FlxSprite();
        _sprite.loadGraphic(AssetPaths.player__png, true, 16, 16);
        _sprite.animation.add("base", [0, 1, 2, 3], 12, true);
        _sprite.animation.play("base");
        
        // Load sprite for the shadow
        _shadowSprite = new FlxSprite();
        _shadowSprite.loadGraphic(AssetPaths.playerShadow__png, true, 16, 16);
        _shadowSprite.animation.add("base", [0, 1], 12, true);
        _shadowSprite.animation.play("base");
        _shadowSprite.alpha = 0.75;
        _shadowSprite.blend = BlendMode.MULTIPLY;
        
        super();
	}
    
    override public function update():Void 
    {
        getInput();
        
        _sprite.setPosition(x, y);
        _sprite.angle = angle;
        _sprite.update();
        
        _shadowSprite.setPosition(x + 3, y + 3);
        _shadowSprite.angle = angle;
        _shadowSprite.update();
        
        velocity.x *= 0.98;
        velocity.y *= 0.98;
		
        super.update();
    }
    
    override public function draw():Void 
    {
        _shadowSprite.draw();
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