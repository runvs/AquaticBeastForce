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
	static private function GetHitpoints(type:String):Float
	{
		if (type == "barrel")
		{
			return 5;
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
		else
		{
			return 16;
		}
	}
	
	public var _sprite:FlxSprite;
	private var _type:String;
	
	private var _health:Float;
	
	private var _state:PlayState;
	
	public function new(X:Float=0, Y:Float=0, type:String, state:PlayState) 
	{
		_type = type;
		_state = state;
		
		var imagepath:String = "assets/images/" + type + ".png";
		//trace ("destoyable constructor: " + imagepath);
		_sprite = new FlxSprite();
		_sprite.loadGraphic(imagepath, true, 16, 16);
		_sprite.setGraphicSize(GetScale(_type), GetScale(_type));
		_sprite.updateHitbox();
		_sprite.animation.add("normal", [0], 30, true);
		_sprite.animation.add("destroyed", [1],30,true);
		_sprite.animation.play("normal");
		
		
		_health = GetHitpoints(_type);
		
		
		super(X, Y);
		
	}
	
	public function TakeDamage(damage:Float):Void
	{
		if (alive && exists)
		{
			_health -=  damage;
			//trace ("remaining health " + _health);
			CheckDead();
		}
	}
	
	private function CheckDead()
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
			
			_state.AddExplosion(new Explosion(x-4 , y-4 ));	// probably just a small explosion?
			var t: FlxTimer = new FlxTimer(0.2, switchImage);	// this timer is needed so the image is flipped after the explosion has started. Fancy juicy shit :D
		}
		
	}
	
	public function switchImage(t:FlxTimer):Void
	{
		_sprite.animation.play("destroyed", true);
	}
	
	override public function draw():Void 
	{
		super.draw();
		_sprite.draw();
	}
	
	override public function update():Void 
	{
		_sprite.x = x;
		_sprite.y = y;
		super.update();
	}
	
	
}