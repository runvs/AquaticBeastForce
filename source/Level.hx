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
	public var _mapObjects1:FlxTilemap;
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
		
		trace("Levelfile parsed");
		
		
		_mapBackground = _map.loadTilemap(AssetPaths.tileset__png, 16, 16, "Background");
		_mapObjects1 = _map.loadTilemap(AssetPaths.objects__png, 16, 16, "Objects1");
		trace("Background created ");
		
		
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
		_mapObjects1.draw();
	}
	
	public override function update():Void
	{
		_mapBackground.update();
		_mapObjects1.update();
	}
	
	
}