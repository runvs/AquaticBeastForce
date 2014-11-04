package ;

import flixel.FlxBasic;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxObject;
import flixel.tile.FlxTilemap;
import flixel.util.FlxVector;

/**
 * ...
 * @author ...
 */
class Level extends FlxBasic
{

	public function new(state: PlayState) 
	{
		_state = state;
		_missionInfo = "";
		super();
	}
	
	private var _state:PlayState;
	
	public var _levelNumber:Int;
	
	private var _map:FlxOgmoLoader;
	public var _mapBackground:FlxTilemap;
	private var _missionInfo:String;
	
	public function LoadLevel(levelNumber:Int)
	{
		_levelNumber = levelNumber;
		
		if (_levelNumber == 1)
		{
			trace("Loading level file " + AssetPaths.Level1__oel);
			_map = new FlxOgmoLoader(AssetPaths.Level1__oel);
		}
		// TODO Extend to more levels
		
		trace("Level loaded");
		_mapBackground = _map.loadTilemap(AssetPaths.tileset__png, 16, 16, "Background");
		
		trace("Background created ");
		//add(_mWalls);
		trace("Background added");
		
		_map.loadEntities(placeEntities, "Entities");
		
		if (_missionInfo == "")
		{
			throw "ERROR: could not load MissionInfo for Level Nr." + _levelNumber;
		}

	}
	
	private function placeEntities(entityName:String, entityData:Xml):Void
	{
		trace("placing entities");
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		if (entityName == "Player")
		{
			_state._player.position = new FlxVector(x,y);
		}
		
		if (entityName == "LevelInfo")
		{
			_missionInfo = entityData.get("MissionInfo");
			trace("MissionType: " + _missionInfo);
		}
		
	}
	
	
	public override function draw():Void
	{
		_mapBackground.draw();
	}
	
	public override function update():Void
	{
		_mapBackground.update();
	}
	
	
}