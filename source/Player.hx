package ;
import flixel.FlxObject;
import flixel.FlxSprite;
import flash.display.BlendMode;
import flixel.FlxG;
import flixel.util.FlxRandom;
import lime.math.Vector2;

/**
 * ...
 * @author Thunraz
 */
class Player extends FlxObject
{
    private var _sprite:FlxSprite;
    private var _shadowSprite:FlxSprite;
    private var _state:PlayState;    
	private var _mgfireTime:Float;
	
	public function new(state:PlayState)
	{   
		_state = state;
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
		
		_mgfireTime = 0;
        
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
		
		_mgfireTime += FlxG.elapsed;
		
		
		
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
		var shot:Bool = FlxG.keys.anyPressed(["Space","X"]);
        
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
		
		if (shot)
		{
			if (_mgfireTime >= GameProperties.PlayerWeaponMgFireTime)
			{
				shoot();
			}
		
		}
    }
    
    private function move(distance:Float):Void
    {
		var rad:Float = angle / 180 * Math.PI;
        var dx:Float = Math.cos(rad) * distance;
        var dy:Float = Math.sin(rad) * distance;
        
        velocity.x += dx;
        velocity.y += dy;
    }
	
	private function shoot():Void
	{
		//trace ("Player Shooting");
		var dangle = FlxRandom.floatRanged( -GameProperties.PlayerWeaponMgSpreadInDegree, GameProperties.PlayerWeaponMgSpreadInDegree);
		var rad:Float = (angle) / 180 * Math.PI;
		var dx:Float = Math.cos(rad) * 7 + 7;
        var dy:Float = Math.sin(rad) * 7 + 7;
		//trace ("Shot created");
		
		
		
		var s:Shot = new Shot(x + dx, y + dy, angle + dangle, ShotType.Rocket, _state);
		_state.AddShot(s);

		//trace ("Shot created");
		_mgfireTime = 0;
		
	}
	
}