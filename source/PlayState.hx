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
import flixel.util.FlxTimer;
import flixel.util.FlxVector;


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
	private var _destroyableList:FlxTypedGroup<DestroyableObject>;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		//FlxG.camera.antialiasing = true;
		_enemies = new FlxTypedGroup<Enemy>();
		_shotlist = new FlxTypedGroup<Shot>();
		_explosionList = new FlxTypedGroup<Explosion>();
		_destroyableList = new FlxTypedGroup<DestroyableObject>();
		
		//add(_enemies);
		trace("playstate create start");
        
        _player = new Player(this);
        trace("Player created");
		
		_level = new Level(this);
		
		var exitByException:Bool = false;
		try 
		{
			_level.loadLevel(1);
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

	
	private function cleanUp():Void
	{
		{
			var newExploList:FlxTypedGroup<Explosion> = new FlxTypedGroup<Explosion>();
			_explosionList.forEach(function(e:Explosion) { if (e.alive) newExploList.add(e); else e.destroy(); } );
			_explosionList = newExploList;
		}
		{
			var newEnemyList:FlxTypedGroup<Enemy> = new FlxTypedGroup<Enemy>();
			_enemies.forEach(function(e:Enemy) { if (e.alive) newEnemyList.add(e); else e.destroy(); } );
			_enemies = newEnemyList;
		}
		{
			var newShotList:FlxTypedGroup<Shot> = new FlxTypedGroup<Shot>();
			_shotlist.forEach(function(s:Shot) { if (s.alive) newShotList.add(s); else s.destroy(); } );
			_shotlist = newShotList;
		}
	}
	
	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		_level.update();
		_destroyableList.update();
        _player.update();
		_enemies.update();
		_shotlist.update();
		_explosionList.update();
		
		cleanUp();
		
		// TODO Rework and Refactor once finished
		for (j in 0..._shotlist.length)
		{
			var s:Shot = _shotlist.members[j];
			if (s.alive && s.exists )
			{
				if (s._shooter)
				{
					for (i in 0..._enemies.length)
					{
						var e:Enemy = _enemies.members[i];
						if (!(e.alive && e.exists))
						{
							continue;
						}

						if (FlxG.overlap(e._sprite, s._sprite))
						{
							if (FlxG.pixelPerfectOverlap(e._sprite, s._sprite,1))
							{
								shotEnemyCollision(e, s);
							}
						}
					}
				}
				else
				{
					if (FlxG.overlap(_player._sprite, s._sprite))
						{
							if (FlxG.pixelPerfectOverlap(_player._sprite, s._sprite,1))
							{
								_player.takeDamage(1.5);
								s.deleteObject();
							}
						}
				}
				for (i in 0 ... _destroyableList.length)
				{
					var d:DestroyableObject = _destroyableList.members[i];
					if (!(d.alive && d.exists))
					{
						continue;
					}
					if (FlxG.overlap(d._sprite, s._sprite))
					{
						if (FlxG.pixelPerfectOverlap(d._sprite, s._sprite,1))
						{
							shotDestroyableCollision(d, s);
						}
					}
				}
			}
		}
		

		
		super.update();
	}

	
	
	public function shotEnemyCollision (e:Enemy, s:Shot):Void
	{
		var vector:FlxVector = new FlxVector(-4, -6);
        //vector = vector.normalize();
		//vector = new FlxVector(vector.x * s._sprite.width * 0.5, vector.y * s._sprite.width * 0.5);
		//vector = new FlxVector(-4, -4);
        //trace(vector);
        addExplosion(new Explosion(s._sprite.x + vector.x , s._sprite.y + vector.y, true));
        s.deleteObject();
		e.takeDamage(1.5);
	}
	
	public function shotDestroyableCollision (d:DestroyableObject, s:Shot):Void
	{
		//trace ("hit");
		s.deleteObject();
		d.takeDamage(1.5);
	}
    
    override public function draw():Void 
    {
		_level.draw();
        _destroyableList.draw();
		_player.draw();
		_enemies.draw();
		_shotlist.draw();
		_explosionList.draw();
		
        super.draw();
    }
	
	public function addEnemy(enemy:Enemy):Void
	{
		_enemies.add(enemy);
		trace ("spawning Enemy");
	}
	public function addShot(shot:Shot):Void
	{
		//trace ("spawning Shot");
		_shotlist.add(shot);
	}
	public function addExplosion(e:Explosion):Void
	{
		_explosionList.add(e);
		
		_enemies.forEach(function(en:Enemy) 
		{ 
			if (en.alive && en.exists)
			{
				var dist = Math.sqrt((en.x -e.x) * (en.x -e.x) + (en.y -e.y) * (en.y -e.y));
				if (dist <= 25)
				{
					trace ("enemy taking Damage from explosion");
					var t: FlxTimer = new FlxTimer(0.23, function(t:FlxTimer) { en.takeDamage(GameProperties.ExplosionDamage); } );	// so they do not explode simulatiously
				}
			}
		} );
		
		_destroyableList.forEach(function(d:DestroyableObject) 
		{ 
			if (d.alive && d.exists)
			{
				var dist = Math.sqrt((d.x -e.x) * (d.x -e.x) + (d.y -e.y) * (d.y -e.y));
				if (dist <= 25)
				{
					trace ("enemy taking Damage from explosion");
					var t: FlxTimer = new FlxTimer(0.23, function(t:FlxTimer) { d.takeDamage(GameProperties.ExplosionDamage); } );	// so they do not explode simulatiously
				}
			}
		} );
		
	}
	public function addDestroyable(d:DestroyableObject):Void
	{
		_destroyableList.add(d);
	}
	
	
}