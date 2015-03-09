package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColorUtil;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxTimer;
import flixel.util.FlxVector;
import haxe.CallStack;


/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{

	private var _player1:Player;
	private var _player2:Player;
	
	private var _level:Level;
	
	private var _enemies:FlxTypedGroup<Enemy>;
	private var _shotlist:FlxTypedGroup<Shot>;
	private var _explosionList:FlxTypedGroup<Explosion>;
	private var _destroyableList:FlxTypedGroup<DestroyableObject>;
	private var _pickUpList:FlxTypedGroup<PickUp>;
	
	private var _upgrade : Upgrade;
	
	private var _overlay : FlxSprite;
	private var _vignette : FlxSprite;
	
	private var _tutorialText : FlxText;

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
		_pickUpList = new FlxTypedGroup<PickUp>();
		_vignette = new FlxSprite();
		_vignette.loadGraphic(AssetPaths.Vignette__png, false, 160, 144);
		_vignette.scrollFactor.set();
		_vignette.origin.set();
		_vignette.alpha = 0.4;
		
		var p : PickUp = new PickUp(new FlxPoint(100, 100));
		_pickUpList.add(p);
		
		//add(_enemies);
		//trace("playstate create start");
        
        _player1 = new Player(this,1);
		_player2 = new Player(this,2);
        //trace("Player created");
		
		_level = new Level(this);
		
		var exitByException:Bool = false;
		try 
		{
			_level.loadLevel(2);
		}
		catch ( msg : String ) 
		{
			trace("Error occurred while loading the level: " + msg);
            trace("Call stack:");
            trace(CallStack.toString(CallStack.exceptionStack()));
			exitByException = true;
		}
		
		if (exitByException)
		{
			throw "I will crash now.";
		}
		
		//add(_level);
		//trace("Level Loaded");
		
		var camera1:FlxCamera = new FlxCamera(0, 0, 80, 144);
		camera1.follow(_player1);
		FlxG.cameras.add(camera1);
		
		var camera2:FlxCamera = new FlxCamera(320, 0, 80, 144);
		camera2.follow(_player2);
		FlxG.cameras.add(camera2);
		
		//FlxG.camera.follow(_player1, FlxCamera.STYLE_TOPDOWN_TIGHT);

		_upgrade = new Upgrade(this);
		
		_overlay = new FlxSprite();
		_overlay.makeGraphic(FlxG.width, FlxG.height, FlxColorUtil.makeFromARGB(1.0, 0, 0, 0));
		_overlay.scrollFactor.set();
		_overlay.origin.set();
		
		FlxTween.tween(_overlay, { alpha:0.0 }, 0.75);
		
		_tutorialText = new FlxText(10, 70, 124, "Please identify yourself as human by pressing [U] for upgrades.", 8);
		_tutorialText.alpha = 1.0;
		_tutorialText.scrollFactor.set();
		FlxTween.tween(_tutorialText, { alpha:0.0 }, 2, {startDelay:2});
		_upgrade.alive = false;
		
		FlxG.mouse.cursorContainer.visible = false;
		
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
			var newEnemyList:FlxTypedGroup<Enemy> = new FlxTypedGroup<Enemy>();
		{
			_enemies.forEach(function(e:Enemy) { if (e.exists) newEnemyList.add(e); else e.destroy(); } );
			_enemies = newEnemyList;
		}
		{
			var newShotList:FlxTypedGroup<Shot> = new FlxTypedGroup<Shot>();
			_shotlist.forEach(function(s:Shot) { if (s.exists ) newShotList.add(s); else s.destroy(); } );
			_shotlist = newShotList;
		}
		//{
			//var newDestrList:FlxTypedGroup<DestroyableObject> = new FlxTypedGroup<DestroyableObject>();
			//_destroyableList.forEach(function(d:DestroyableObject) { if (d.alive) newDestrList.add(d); else d.destroy(); } );
			//_destroyableList = newDestrList;
		//}
	}
	
	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		if (!_upgrade.alive)
		{		
			FlxG.mouse.cursorContainer.visible = false;
			_level.update();
			_destroyableList.update();
			_player1.update();
			_player2.update();
			_enemies.update();
			_shotlist.update();
			_explosionList.update();
			_pickUpList.update();
			_overlay.update();
			
			//FlxG.collide(_enemies, _level._mapObjects1);
			FlxG.collide(_enemies, _enemies);
			
			cleanUp();
			
			CheckEndCondition();
			
			FlxG.overlap(_player1._sprite, _pickUpList, DoPlayerPickUp);
			
			HandleCollisions();
			
			CheckEndCondition();
			if (FlxG.keys.justPressed.U)
			{
				ShowUpgrades();
			}
		}
		else
		{
			FlxG.mouse.cursorContainer.visible = true;
			_upgrade.update();
			
			
		}
		super.update();
	}

	public function DoPlayerPickUp(player:FlxSprite, p:PickUp) : Void 
	{
		if (p.alive)
		{
			_player1.AddPickUp(p);
			p.kill();
		}
	}
	
	private function CheckEndCondition():Void
	{
		
		if (_player1._dead)
		{
			// Player lost
			FlxG.switchState(new GameOverState(false));
		}
		
		if (_level._missionInfo == "attack")
		{
			if (CheckAllTargetsDead())
			{
				// Player won
				FlxG.switchState(new GameOverState(true));
			}
		}
		else if (_level._missionInfo == "defend")
		{
			
		}
		else if (_level._missionInfo == "escort")
		{
			
		}
		else if (_level._missionInfo == "rescue")
		{
			
		}
	}
	
	private function CheckAllTargetsDead():Bool
	{
		for (i in 0 ... _level._targets.length)
		{
			var n:String = _level._targets[i];
			
			for (j in 0 ... _enemies.length)
			{
				var e:Enemy = _enemies.members[j];
                if ( e.name == n) 
                {
                    return false;
                }
			}
			for (j in 0 ... _destroyableList.length)
			{
				var e:DestroyableObject = _destroyableList.members[j];
				if ( e.name == n && e.alive && e.exists) 
				{
					return false;
				}
			}
		}
		return true;
	}
	
	public function shotEnemyCollision (e:Enemy, s:Shot):Void
	{
        addExplosion(new Explosion(s.sprite.x - 4, s.sprite.y - 6, true));
        s.deleteObject();
		e.takeDamage(s.getDamage());
	}
	
	public function shotDestroyableCollision (d:DestroyableObject, s:Shot):Void
	{
		addExplosion(new Explosion(s.sprite.x - 4, s.sprite.y - 4, true));
		s.deleteObject();
		d.takeDamage(s.getDamage());
	}
	
	public function getNearestEnemy():Enemy 
	{
		var ret:Enemy = null;
		var distancelargest:Float = 999999;
		for (i in 0 ... _enemies.length)
		{
			var e:Enemy = _enemies.members[i];
			if (!e.alive) continue;
			
			var dx:Float = e.x - _player1.x;
			var dy:Float = e.y - _player1.y;
			
			// todo remove sqrt here
			
			var d:Float = Math.sqrt(dx * dx + dy * dy);
			
			if (d < GameProperties.AutoCannonRange)
			{
				if (d < distancelargest)
				{
					distancelargest = d;
					ret = e;
				}
			}
		}
		return ret;
	}
    
    override public function draw():Void 
    {
			
		_level.draw();
        _destroyableList.draw();

		_enemies.draw();
		_player1.draw();
		_player2.draw();
		_shotlist.draw();
		_explosionList.draw();
		
		_pickUpList.draw();
		_overlay.draw();
		
		_tutorialText.draw();
		drawHud();
		if (_upgrade.alive)
		{	
			_upgrade.draw();
		}
		
		
        super.draw();
		_vignette.draw();
    }
	
	private function drawHud():Void
	{
		_player1.drawHud();
		if (_level._missionInfo == "attack")
		{
			for (i in 0 ... _level._targets.length)
			{
				var n:String = _level._targets[i];
				for (j in 0 ... _enemies.length)
				{
					var e:Enemy = _enemies.members[j];
					if ( e.name == n) 
					{
						_player1.drawLocator(e.x, e.y);
						return;
					}
				}
				for (j in 0 ... _destroyableList.length)
				{
					var e:DestroyableObject = _destroyableList.members[j];
					if (e.alive && e.name == n) 
					{
						var offset:Float = Std.int(DestroyableObject.GetScale(e._type).x) * 0.5;
						_player1.drawLocator(e.x + offset, e.y + offset);
						return;
					}
				}
			}
		}
		
		
		
	}
	
	function HandleCollisions():Void 
	{
		for (j in 0..._shotlist.length)
		{
			var s:Shot = _shotlist.members[j];
			if (s.alive && s.exists )
			{
				if (s.isPlayer)
				{
					for (i in 0..._enemies.length)
					{
						var e:Enemy = _enemies.members[i];
						if (!(e.alive && e.exists))
						{
							continue;
						}
						if (e.isGround && s.type == ShotType.RocketAirAir)
						{
							continue;
						}
						if (!e.isGround && s.type == ShotType.RocketAirGround)
						{
							continue;
						}
						if (FlxG.overlap(e.sprite, s.sprite))
						{
							if (FlxG.pixelPerfectOverlap(e.sprite, s.sprite,1))
							{
								shotEnemyCollision(e, s);
							}
						}
					}
				}
				else
				{
					if (FlxG.overlap(_player1._sprite, s.sprite))
						{
							if (FlxG.pixelPerfectOverlap(_player1._sprite, s.sprite,1))
							{
								_player1.takeDamage(1.5);
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
					if (FlxG.overlap(d.sprite, s.sprite))
					{
						if (FlxG.pixelPerfectOverlap(d.sprite, s.sprite,1))
						{
							shotDestroyableCollision(d, s);
						}
					}
				}
			}
		}
	}
	
	public function ShowUpgrades():Void 
	{
		_upgrade.alive = true;
	}
	
	public function addEnemy(enemy:Enemy):Void
	{
		_enemies.add(enemy);
		//trace ("spawning Enemy");
	}
	public function addShot(shot:Shot):Void
	{
		//trace ("spawning Shot");
		_shotlist.add(shot);
	}
	public function addExplosion(e:Explosion):Void
	{
		_explosionList.add(e);
		if (!e._isSmallExplosion)
		{
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
	}
	public function addDestroyable(d:DestroyableObject):Void
	{
		_destroyableList.add(d);
	}
	public function addPickUp(p:PickUp) : Void 
	{
		_pickUpList.add(p);
	}
	
	public function PlayerDead():Void
	{
		_enemies.forEach(function(e:Enemy):Void { e.UnseePlayer(); } );
	}
	
	public function setPlayersRespawn (p :FlxPoint, moveToPosition:Bool):Void
	{
		_player1.setRespawnPosition(p, moveToPosition);
		_player2.setRespawnPosition(p, moveToPosition);
	}
	
	public function getNearestPlayer ( p:FlxPoint) : FlxVector
	{
		var t1 :FlxVector = new FlxVector(_player1.x - p.x, _player1.y - p.y);
		var t2 :FlxVector = new FlxVector(_player2.x - p.x, _player2.y - p.y);
		
		if (t1.lengthSquared < t2.lengthSquared)
		{
			return new FlxVector(_player1.x, _player1.y);
		}
		else
		{
			return new FlxVector(_player2.x, _player2.y);
		}
	}
	
}