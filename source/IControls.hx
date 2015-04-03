package ;

/**
 * @author 
 */

interface IControls 
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
	
	public function getRotationFactor() : Float;
	
	
	public function update () : Void;
}