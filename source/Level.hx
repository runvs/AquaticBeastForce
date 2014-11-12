package ;

import flixel.FlxBasic;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxObject;
import flixel.tile.FlxTilemap;
import flixel.util.FlxPoint;
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
	public var _missionInfo:String;
	public var _targets:Array<String>;
	
	public function loadLevel(levelNumber:Int)
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
			_state._player.setRespawnPosition(new FlxPoint(x, y), true);
			//_state._player.x = x;
            //_state._player.y = y;
		}
		
		if (entityName == "LevelInfo")
		{
			_missionInfo = entityData.get("MissionInfo");
			trace("MissionType: " + _missionInfo);
			_targets = entityData.get("targets").split(",");
			trace(_targets);
		}
		if (entityName == "Enemy")
		{
			var enemyType:String = entityData.get("Type");
			
			var type:EnemyType = Enemy.TypeFromString(enemyType);
			
			var enemy : Enemy  = new Enemy(type, _state);
			enemy.x = x;
			enemy.y = y;
			enemy._name = entityData.get("Name");
			_state.addEnemy(enemy);
		}
		if (entityName == "Destroy")
		{
			trace ("creating destoyable object");
			var type:String = entityData.get("Type");
			var d : DestroyableObject = new  DestroyableObject(x, y, type, _state);
			d._name = entityData.get("Name");
			_state.addDestroyable(d);
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