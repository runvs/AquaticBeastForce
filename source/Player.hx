package ;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxVector;
import flixel.util.FlxColor;

/**
 * ...
 * @author Thunraz
 */
class Player extends FlxBasic
{
    public var position:FlxVector;
    private var _sprite:FlxSprite;
    
	public function new(x:Float, y:Float)
	{
		position = new FlxVector(x, y);
        
        _sprite = new FlxSprite(position.x, position.y);
        _sprite.makeGraphic(16, 16, FlxColor.BLUE);
        
        super();
	}
    
    override public function update():Void 
    {
        getInput();
        _sprite.setPosition(position.x, position.y);
        
        super.update();
    }
    
    override public function draw():Void 
    {
        _sprite.draw();
        super.draw();
    }
    
    private function getInput():Void
    {
        
    }
}