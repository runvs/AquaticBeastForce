package ;
import flixel.util.FlxSave;

/**
 * ...
 * @author 
 */
class Achievments
{

	private static var _save : FlxSave;
	
	public function new() 
	{
		
	}
	
	private static var _enemiesKilled001 : Bool;
	private static var _enemiesKilled010 : Bool;
	private static var _enemiesKilled050 : Bool;
	private static var _enemiesKilled100 : Bool;
	
	private static var _display : IDisplayAchievment;
	
	public static function setCallbacker ( display : IDisplayAchievment) : Void 
	{
		_display = display;
	}
	
	
	public static function init () : Void 
	{
		_save = new FlxSave();
		_save.bind("achievments");
		
		// try to load achievments-save
		if (_save.data._enemiesKilled001 == null)
		{
			// no saved achievments, write default values.
		
			_save.data._enemiesKilled001 = false;	// for whatever reason this works... o_O
			_save.data._enemiesKilled010 = false;
			_save.data._enemiesKilled050 = false;
			_save.data._enemiesKilled100 = false;
		}
		else
		{
			_enemiesKilled001 = _save.data._enemiesKilled001;
			_enemiesKilled010 = _save.data._enemiesKilled010;
			_enemiesKilled050 = _save.data._enemiesKilled050;
			_enemiesKilled100 = _save.data._enemiesKilled100;
		}
	}
	
	public static function save () : Void 
	{
		_save.data._enemiesKilled001 = _enemiesKilled001;
		_save.data._enemiesKilled010 = _enemiesKilled010;
		_save.data._enemiesKilled050 = _enemiesKilled050;
		_save.data._enemiesKilled100 = _enemiesKilled100;
		_save.flush();
	}
	
	public static function update() : Void 
	{
		checkAnalytics();
	}
	
	private static function checkAnalytics () : Void 
	{
		if (_enemiesKilled001 == false)
		{
			if ( Analytics.getNumberOfDeadEnemies() >= 1)
			{
				_display.DisplayAchievmentMessage("1 Enemy killed");
				_enemiesKilled001 = true;
			}
		}
		
		if (_enemiesKilled010 == false)
		{
			if ( Analytics.getNumberOfDeadEnemies() >= 10)
			{
				_display.DisplayAchievmentMessage("10 Enemies killed");
				_enemiesKilled010 = true;
			}
		}
		
		if (_enemiesKilled050 == false)
		{
			if ( Analytics.getNumberOfDeadEnemies() >= 50)
			{
				_display.DisplayAchievmentMessage("50 Enemies killed");
				_enemiesKilled050 = true;
			}
		}
		
		if (_enemiesKilled100 == false)
		{
			if ( Analytics.getNumberOfDeadEnemies() >= 100)
			{
				_display.DisplayAchievmentMessage("100 Enemies killed");
				_enemiesKilled100 = true;
			}
		}
	}
}