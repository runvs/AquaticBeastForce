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
		super();
	}
	
	private var _state:PlayState;
	
	public var _levelNumber:Int;
	
	private var _map:FlxOgmoLoader;
	public var _mWalls:FlxTilemap;
	
	
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
		_mWalls = _map.loadTilemap(AssetPaths.tileset__png, 16, 16, "Walls");
		
		_mWalls.setTileProperties(1, FlxObject.NONE);
		_mWalls.setTileProperties(2, FlxObject.ANY);
		trace("Background created ");
		//add(_mWalls);
		trace("Background added");
		
		_map.loadEntities(placeEntities, "Entities");

	}
	
	private function placeEntities(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		if (entityName == "player")
		{
			_state._player.Position = new FlxVector(x,y);
			//_state._player.x = x;
			//_state._player.y = y;  
		}
	}
	
	
	public override function draw():Void
	{
		_mWalls.draw();
	}
	
	public override function update():Void
	{
		_mWalls.update();
	}
	
	
}