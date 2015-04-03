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
import flixel.util.FlxRandom;
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
	
	private var camera1:FlxCamera;
	private var camera2:FlxCamera;
	private var cameraVignette:FlxCamera;
	private var _blackScreen:FlxSprite;
	
	private var twoPlayer:Bool;	// true if two players, false if one player
	

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		twoPlayer = true;
		
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
		
		_blackScreen = new FlxSprite();
		_blackScreen.makeGraphic(160, 144, FlxColorUtil.makeFromARGB(1.0, 0, 0, 0));
		_blackScreen.scrollFactor.set();
		_blackScreen.origin.set();
		
		var p : PickUp = new PickUp(new FlxPoint(100, 100));
		_pickUpList.add(p);
		
		_upgrade = new Upgrade(this);	
		_upgrade.alive = false;
		
		_overlay = new FlxSprite();
		_overlay.makeGraphic(FlxG.width, FlxG.height, FlxColorUtil.makeFromARGB(1.0, 0, 0, 0));
		_overlay.scrollFactor.set();
		_overlay.origin.set();
		
		FlxTween.tween(_overlay, { alpha:0.0 }, 0.75);
		
		_tutorialText = new FlxText(10, 70, 124, "Please identify yourself as human by pressing [U] for upgrades.", 8);
		_tutorialText.alpha = 1.0;
		_tutorialText.scrollFactor.set();
		FlxTween.tween(_tutorialText, { alpha:0.0 }, 2, {startDelay:2});
		
		
		FlxG.mouse.cursorContainer.visible = false;
		
		if (twoPlayer)
		{
			camera1 = new FlxCamera(0, 0, 80, 144);
			camera2 = new FlxCamera(320, 0, 80, 144);
			cameraVignette =  new FlxCamera(0, 0, 160, 144);
			_player1 = new Player(this, 1);
			_player2 = new Player(this, 2);
			
			camera1.follow(_player1);
			camera2.follow(_player2);
			
			FlxG.cameras.add(camera1);
			FlxG.cameras.add(camera2);
			FlxG.cameras.add(cameraVignette);
		}
		else
		{
			// TODO TEST!!
			camera1 = new FlxCamera(0, 0, 160, 144);
			cameraVignette =  new FlxCamera(0, 0, 160, 144);
			_player1 = new Player(this, 1);
			camera1.follow(_player1);
			FlxG.cameras.add(camera1);
			FlxG.cameras.add(cameraVignette);
		}
		

		
		LoadLevel();

		super.create();
	}
	
		function LoadLevel():Void 
	{
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
			_enemies.update();
			_shotlist.update();
			_explosionList.update();
			_pickUpList.update();
			_overlay.update();
			
			if (twoPlayer)
			{
				if (!_player1._dead)
				{
					_player1.update();
					PickupMagnet(_player1);
				}
				if (!_player2._dead)
				{
					_player2.update();
					PickupMagnet(_player2);
				}
			}
			else
			{
				_player1.update();
				PickupMagnet(_player1);
			}
			
			
			FlxG.collide(_enemies, _enemies);
			cleanUp();
			
			CheckEndCondition();
            
			
			FlxG.overlap(_player1._sprite, _pickUpList, DoPlayerPickUp1);
			FlxG.overlap(_player2._sprite, _pickUpList, DoPlayerPickUp2);
			
			HandleCollisions();
			
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

	public function DoPlayerPickUp1(player:FlxSprite, p:PickUp) : Void 
	{
		if (p.alive)
		{
			_player1.AddPickUp(p);
			p.kill();
		}
	}
	public function DoPlayerPickUp2(player:FlxSprite, p:PickUp) : Void 
	{
		if (p.alive)
		{
			_player2.AddPickUp(p);
			p.kill();
		}
	}
	
	private function CheckEndCondition():Void
	{
	
		if (twoPlayer)
		{
			if (_player1._dead && _player2._dead)
			{
				// Player lost
				var s : GameOverState = new GameOverState(false);
				s.SetPoints(_player1.TotalPoints, _player2.TotalPoints);
				FlxG.switchState(s);
			}
		}
		else
		{
			if (_player1._dead)
			{
				// Player lost
				var s : GameOverState = new GameOverState(false);
				s.SetPoints(_player1.TotalPoints, 0);
				FlxG.switchState(s);
			}
		}
		
		if (_level._missionInfo == "attack")
		{
			if (CheckAllTargetsDead())
			{
				// Player won
				var s : GameOverState = new GameOverState(true);
				s.SetPoints(_player1.TotalPoints, _player2.TotalPoints);
				FlxG.switchState(s);
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
	
    private function PickupMagnet(pl : Player):Void
    {
        for (i in 0 ... _pickUpList.length)
        {
            var p:PickUp = _pickUpList.members[i];
            var distanceX:Float = p.x - pl.x;
            var distanceY:Float = p.y - pl.y;

            var distance:Float = distanceX * distanceX + distanceY * distanceY;
            if (distance < GameProperties.PickUpMagnetDistance * GameProperties.PickUpMagnetDistance)
            {
                var distanceRoot:Float = Math.sqrt(distance);
                var coefficent:Float = -1.0 / distanceRoot * (1.0 - distanceRoot / GameProperties.PickUpMagnetDistance) * GameProperties.PickUpMagnetMaxVelocity;

                p.velocity.x = distanceX * coefficent;
                p.velocity.y = distanceY * coefficent;
            }
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
		e.setLastHit(s._playerNumber);
	}
	
	public function shotDestroyableCollision (d:DestroyableObject, s:Shot):Void
	{
		addExplosion(new Explosion(s.sprite.x - 4, s.sprite.y - 4, true));
		s.deleteObject();
		d.takeDamage(s.getDamage());
		d.setLastHit(s._playerNumber);
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
		// remove vignette camera since only vignette should be drawn to this cam
		FlxG.cameras.remove(cameraVignette, false);
		
		// draw to both
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
		
		FlxG.cameras.remove(camera1, false);
		FlxG.cameras.remove(camera2, false);
		FlxG.cameras.add(cameraVignette);
		cameraVignette.bgColor = FlxColorUtil.makeFromARGB(0.0, 0, 0, 0);
		_vignette.draw();
		
		FlxG.cameras.remove(cameraVignette, false);
		
		FlxG.cameras.add(camera1);
		FlxG.cameras.add(camera2);
		FlxG.cameras.add(cameraVignette);
		
		
		
		
    }
	
	private function drawHud():Void
	{
		FlxG.cameras.remove(camera2, false);
		
		_player1.drawHud();
		DrawLocator(_player1);
		
		if (_player1._dead)
		{
			_blackScreen.draw();
		}
	
		
		
		FlxG.cameras.remove(camera1, false);
		FlxG.cameras.add(camera2);
		_player2.drawHud();
		DrawLocator(_player2);
		if (_player2._dead)
		{
			_blackScreen.draw();
		}
		
	
		
		FlxG.cameras.add(camera1);
		
	}
	
	function HandleCollisions():Void 
	{
		for (j in 0..._shotlist.length)
		{
			var s:Shot = _shotlist.members[j];
			if (s.alive && s.exists )
			{
				if (s.isPlayer())
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
							_player1.takeDamage(s.getDamage());
							s.deleteObject();
						}
					}
					if (FlxG.overlap(_player2._sprite, s.sprite))
					{
						trace ("test");
						if (FlxG.pixelPerfectOverlap(_player2._sprite, s.sprite,1))
						{
							_player2.takeDamage(s.getDamage());
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
	
	function DrawLocator(p:Player):Void 
	{
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
						p.drawLocator(e.x, e.y);
						return;
					}
				}
				for (j in 0 ... _destroyableList.length)
				{
					var e:DestroyableObject = _destroyableList.members[j];
					if (e.alive && e.name == n) 
					{
						var offset:Float = Std.int(DestroyableObject.GetScale(e._type).x) * 0.5;
						p.drawLocator(e.x + offset, e.y + offset);
						return;
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
	
	public function addPoints (p : Int, playerNumber : Int = -1 )
	{
		if (playerNumber == -1)
		{
			var s : Int = FlxRandom.sign();
			_player1.ChangePoints(Std.int(p/2 +( 0.5 * s)));
			_player2.ChangePoints(Std.int(p/2 -( 0.5 * 2)));
		}
		else if (playerNumber == 2)
		{
			_player2.ChangePoints(p);
		}
		else
		{
			_player1.ChangePoints(p);
		}
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