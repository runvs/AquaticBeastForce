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
	public var _mgDamgeBase:Float = 1.5;
	public var _mgDamageFactor:Float = 1.0;
	
	public var _rocketAirGroundDamageBase:Float = 3.0;
	public var _rocketAirGroundDamageFactor:Float = 1.0;
	
	public var _rocketAirAirDamageBase:Float = 4.0;
	public var _rocketAirAirDamageFactor:Float = 1.0;
	
	public var _bfgDamageBase:Float = 7.0;
	public var _bfgDamageFactor:Float = 1.0;
	
	public var _specialWeaponFireTimeMax:Float = 1.15;
	
	

	
}