package ;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxVector;

/**
 * ...
 * @author 
 */
class Engineer extends GameObject
{
	public function new(state:PlayState) 
	{
		super();
		_state = state;
		sprite = new FlxSprite();
		sprite.loadGraphic(AssetPaths.engineer__png, false, 16, 16);
		
	}
	
	override public function update():Void 
    {
		
		var p : Player = _state.getNearestPlayer(new FlxPoint(this.x, this.y));
		
		var dir : FlxVector  = new FlxVector(p.x - this.x, p.y - this.y);
		
		var dirn : FlxVector = dir.normalize();
		
		this.velocity.x = dirn.x * GameProperties.EngineerMoveSpeed;
		this.velocity.y = dirn.y * GameProperties.EngineerMoveSpeed;
		sprite.angle = dir.degrees;
		sprite.x = x;
		sprite.y = y;
		super.update();
	}
	
	 public override function draw():Void
    {
		sprite.draw();
	}
	
	public override function kill():Void
	{
		alive = false;
		exists = false;
	}
}