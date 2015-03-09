package ;

/**
 * ...
 * @author Thunraz
 */
class GameProperties
{
    public static var PlayerMovementSpeed:Float = 60;
    public static var PlayerRotationSpeed:Float = 2.5;

	public static var PlayerWeaponMgSpreadInDegree = 6;
	
	public static var PlayerHealthDefault:Float = 25;
	public static var UpgradeHealthAdd:Float = 5;
	public static var PlayerLivesDefault:Int = 0;

	public static var EnemyViewRange:Float = 60;
	
	public static var EnemySoldierMovementSpeed:Float = 9;
	public static var EnemySoldiersTurnSpeed:Float = 2;
	public static var EnemySoldierDefaultHealth:Float = 2;
	public static var EnemySoldierShootInterval:Float = 0.75;
	public static var EnemySoldierDamage:Float = 1;
	
	public static var EnemyTankMovementSpeed:Float = 25;
	public static var EnemyTankTurnSpeed:Float = 0.75;
	public static var EnemyTankDefaultHealth:Float = 14;
	public static var EnemyTankShootInterval:Float = 1.5;
	public static var EnemyTankDamage:Float = 4;
	
	public static var EnemySamTurnSpeed:Float = 1.15;
	public static var EnemySamDefaultHealth:Float = 14;
	public static var EnemySamShootInterval:Float = 0.85;
	public static var EnemySamDamage:Float = 7;
	
	public static var EnemyHeliMovementSpeed:Float = 30;
	public static var EnemyHeliTurnSpeed:Float = 2;
	public static var EnemyHeliDefaultHealth:Float = 10;
	public static var EnemyHeliShootInterval:Float = 0.35;
	public static var EnemyHeliDamage:Float = 3;
	
	public static var ShotBallisticMovementSpeed:Float = 100;
	public static var ShotBallisticLifeTime:Float = 0.35;
	
	public static var ShotMGMovementSpeed:Float = 120;
	public static var ShotMGLifeTime:Float = 0.25;
	
	public static var ShotMGSmallLifeTime:Float = 0.25;
	
	public static var ShotBFGMovementSpeed:Float = 140;
	public static var ShotBFGLifeTime:Float = 0.5;
	
	public static var ShotRocketLifeTime:Float = 1;
	public static var ShotRocketMoveSpeedInitial:Float = 70.0;
	
	public static var ExplosionDamage:Float = 7;
	
	public static var AutoCannonRange:Float = 50;
	
	public static var PickUpDropChance: Float = 0.2;
	
	public static var p1Controls : Controls = new Controls(ControlType.GamePad);
	public static var p2Controls : Controls = new Controls(ControlType.Keyboard);
	
}