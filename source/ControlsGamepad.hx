package ;
import flixel.FlxG;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.XboxButtonID;
import flixel.util.FlxPoint;

/**
 * ...
 * @author 
 */
class ControlsGamepad implements IControls
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
	private var _gamePad:FlxGamepad;
	
	
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
	
		_gamePad = FlxG.gamepads.lastActive;
		if (_gamePad == null) {
			return;
		}
		
		if (_gamePad == null) {
			return;
		}
		var la : FlxPoint = updateAxis(GamepadIDs.LEFT_ANALOGUE_X, GamepadIDs.LEFT_ANALOGUE_Y);
		// note the wrong axis numbers! For whatever reason this behaves wrong.
		var ra :FlxPoint = updateAxis(GamepadIDs.RIGHT_ANALOGUE_Y, GamepadIDs.RIGHT_ANALOGUE_X);
		//trace (ra);
		if ( ra.x < 0 )
		{
			left = true;
		}
		else if ( ra.x > 0 )
		{
			right = true;
		}

		if ( la.x < 0 )
		{
			strafeLeft = true;
		}
		else if ( la.x > 0 )
		{
			strafeRight = true;
		}


		if ( la.y > 0 )
		{
			down = true;
		}
		else if ( la.y < 0 )
		{
			up = true;
		}
		
		var dpadLeft = _gamePad.pressed(XboxButtonID.DPAD_LEFT);
		var dpadRight = _gamePad.pressed(XboxButtonID.DPAD_RIGHT);
		var dpadUp = _gamePad.pressed(XboxButtonID.DPAD_UP);
		var dpadDown = _gamePad.pressed(XboxButtonID.DPAD_DOWN);
		
		
		if (_gamePad.pressed(XboxButtonID.RIGHT_TRIGGER))
		{
			shot = true;
		}

		if (_gamePad.pressed(XboxButtonID.LEFT_TRIGGER))
		{
			showUpdates = true;
		}
		
		
		
	}
	
	private function updateAxis(xID:Int, yID:Int): FlxPoint
	{

		var p : FlxPoint = new FlxPoint();
		if (_gamePad == null) {
			return p;
		}
		
		var xAxisValue = _gamePad.getXAxis(xID);
		var yAxisValue = _gamePad.getYAxis(yID);
		
		p.x = xAxisValue;
		p.y = yAxisValue;
		
		return p;
	}
	
	public function getRotationFactor() : Float
	{
		return 0.75;
	}
}