package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import lime.math.Vector2;


/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{

	public var _player:Player;
	private var _level:Level;
	
	private var _enemies:FlxTypedGroup<Enemy>;
	private var _shotlist:FlxTypedGroup<Shot>;
	private var _explosionList:FlxTypedGroup<Explosion>;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		_enemies = new FlxTypedGroup<Enemy>();
		_shotlist = new FlxTypedGroup<Shot>();
		_explosionList = new FlxTypedGroup<Explosion>();
		
		//add(_enemies);
		trace("playstate create start");
        
        _player = new Player(this);
        trace("Player created");
		
		_level = new Level(this);
		
		var exitByException:Bool = false;
		try 
		{
			_level.LoadLevel(1);
		}
		catch ( msg : String ) 
		{
			trace("Error occurred while loading the level: " + msg);
			exitByException = true;
		}
		
		if (exitByException)
		{
			throw "I will crash now.";
		}
		
		//add(_level);
		trace("Level Loaded");
        
        add(_player);
		
		FlxG.camera.follow(_player, FlxCamera.STYLE_TOPDOWN);

		
		super.create();
	}
	
	
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		_level.update();
        _player.update();
		_enemies.update();
		_shotlist.update();
		_explosionList.update();

		//FlxG.overlap(_enemies, _shotlist, shotEnemyCollision);
		var newEList:FlxTypedGroup<Enemy> = new FlxTypedGroup<Enemy>();
		for (i in 0..._enemies.length)
		{
			var e:Enemy = _enemies.members[i];
			if (e.alive && e.exists)
			{
					newEList.add(e);
			}
			else 
			{
				continue;
			}
			
			for (j in 0..._shotlist.length)
			{
				
				var s:Shot = _shotlist.members[j];
				if (s.alive && s.exists)
				{

					//trace ("checkcollision");
					var pos1:Vector2 = new Vector2(e.x+8, e.y+8);
					var pos2:Vector2 = new Vector2(s.x, s.y);
					var distance:Vector2 = new Vector2(pos1.x - pos2.x, pos1.y - pos2.y);

					if (distance.length <= 5)
					{
						
						shotEnemyCollision(e, s);
					}
				}
			}
			
		}
		_enemies = newEList;
		
		super.update();
	}

	
	
	public function shotEnemyCollision (e:Enemy, s:Shot):Void
	{
		//trace ("hit");
		s.kill();
		//e.takeDamage();
	}
	

    
    override public function draw():Void 
    {
		_level.draw();
        _player.draw();
		_enemies.draw();
		_shotlist.draw();
		_explosionList.draw();
        super.draw();
    }
	
	public function AddEnemy(enemy:Enemy):Void
	{
		_enemies.add(enemy);
		trace ("spawning Enemy");
	}
	public function AddShot(shot:Shot):Void
	{
		//trace ("spawning Shot");
		_shotlist.add(shot);
	}
	public function AddExplosion(e:Explosion):Void
	{
		_explosionList.add(e);
	}
	
	
}