package ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxVector;
import flixel.util.FlxColor;

/**
 * ...
 * @author Thunraz
 */
class Player
{
    public var position:FlxVector;
    private var _sprite:FlxSprite;

	public function new(x:Float, y:Float)
	{
		Position = new FlxVector(x, y);
        
        _sprite = new FlxSprite(Position.x, Position.y);
        _sprite.makeGraphic(16, 16, FlxColor.BLUE);
	}
    
    public function update():Void
    {
        getInput();
        
        _sprite.setPosition(Position.x, Position.y);
    }
    
    public function draw():Void
    {
        _sprite.draw();
    }
    
    private funtion getInput():Void
    {
        
    }
}