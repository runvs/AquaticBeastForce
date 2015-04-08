package ;
import flixel.FlxG;

/**
 * ...
 * @author 
 */
class ControlsKeyboard implements IControls
{
  	public var up:Bool;
	public var down:Bool;
	public var left:Bool;
	public var right:Bool;
	public var strafeRight:Bool;
	public var strafeLeft:Bool;
	public var shot:Bool;
	public var suicide:Bool;
	public var showUpdates: Bool;
	
	public function new() 
	{
	}
	
	/* INTERFACE IController */
	
	public function update():Void 
	{
		up = false;
		down = false;
		left = false;
		right = false;
		strafeRight = false;
		strafeLeft = false;
		shot = false;
		showUpdates = false;
	
		
		up = FlxG.keys.anyPressed(["W", "UP"]);
		down = FlxG.keys.anyPressed(["S", "DOWN"]);
		left = FlxG.keys.anyPressed(["A", "LEFT"]);
		right = FlxG.keys.anyPressed(["D", "RIGHT"]);
		strafeRight = FlxG.keys.pressed.E;
		strafeLeft = FlxG.keys.pressed.Q;
		shot = FlxG.keys.anyPressed(["Space", "X"]);
		showUpdates = FlxG.keys.justPressed.P;
	}
	
	public function getRotationFactor() : Float
	{
		return 1.0;
	}
	
}