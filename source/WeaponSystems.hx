package ;

/**
 * ...
 * @author ...
 */
class WeaponSystems
{

	public function new() 
	{
		_hasAirAirRockets = _hasAirGroundRockets = _hasAutoTurret = _hasBFG = _hasLaser = false;
	}
	
	public var _hasAirAirRockets:Bool;
	public var _hasAirGroundRockets:Bool;
	public var _hasAutoTurret:Bool;
	public var _hasLaser:Bool;
	public var _hasBFG:Bool;
	
	public var _mgFireTimeMax:Float = 0.175;
	
	public var _specialWeaponFireTimeMax:Float = 1.15;
	

	
}