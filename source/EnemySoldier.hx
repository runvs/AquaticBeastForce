package ;
import flixel.FlxSprite;
import flixel.util.FlxVector;
import flash.display.BlendMode;
import flixel.FlxG;

/**
 * ...
 * @author Thunraz
 */
class EnemySoldier extends Enemy
{

    public function new(state:PlayState) 
    {
        type = EnemyType.Soldiers;
        _state = state;
        
        // ************
        // * tweak me *
        // ************
        var mainSprite:String = AssetPaths.enemySoldier__png;
        var shadowSprite:String = AssetPaths.enemySoldierShadow__png;
        var animationSpeed = 12;
        
        var mainAnimation = [0];
        var shadowAnimation = [0];
        _shadowDistance = 1;
        
        _health = _healthMax = GameProperties.EnemyTankDefaultHealth;
        _shootTimer = _shootTimerMax = 1;
        isGround = true;
        // **********************
        // * stop tweaking here *
        // **********************
        
        // Load sprite for the enemy
        sprite = new FlxSprite();
        sprite.loadGraphic(mainSprite, true, 16, 16);
        sprite.animation.add("base", mainAnimation, animationSpeed, true);
        sprite.animation.play("base");
        
        // Load sprite for the shadow
        _shadowSprite = new FlxSprite();
        _shadowSprite.loadGraphic(shadowSprite, true, 16, 16);
        _shadowSprite.animation.add("base", shadowAnimation, animationSpeed, true);
        _shadowSprite.animation.play("base");
        _shadowSprite.alpha = 0.75;
        _shadowSprite.blend = BlendMode.MULTIPLY;
        
        super();
    }
	
	 override public function update():Void 
    {
		var playerPos:FlxVector= new FlxVector(_state._player.x, _state._player.y);
		var soldierPos:FlxVector  = new FlxVector(x,y);
		
		var direction:FlxVector = new FlxVector(playerPos.x - soldierPos.x,playerPos.y - soldierPos.y);
		var l = direction.length;
		if (_hasSeenPlayer)
		{
			// drive towards player
			
			
			var targetAngle:Float = direction.degrees;
			var currentAngle:Float = angle;
			
			var angleDifference:Float = targetAngle - currentAngle;
			
			if (angleDifference > 0 && angleDifference >= GameProperties.EnemySoldiersTurnSpeed)
			{
				angleDifference = GameProperties.EnemySoldiersTurnSpeed;
			}
			else if (angleDifference <= 0 && angleDifference <= GameProperties.EnemySoldiersTurnSpeed)
			{
				angleDifference = -GameProperties.EnemySoldiersTurnSpeed;
			}

			currentAngle+= angleDifference;
			
			var rad:Float = currentAngle / 180 * Math.PI;
			var dx:Float = Math.cos(rad);
			var dy:Float = Math.sin(rad);
			
			direction = new FlxVector(dx, dy);
			angle = direction.degrees;
			
			if(l >= 40)
			{
				direction = direction.normalize();
				
				var tmp:Float = GameProperties.EnemySoldierMovementSpeed * FlxG.elapsed;
				
				velocity.x += direction.x * tmp;
				velocity.y += direction.y * tmp;
			}
			
					
			
			var angletoTurn = targetAngle - currentAngle;
			if ( Math.abs(angletoTurn) <= 1 && l <= 120)
			{
				shoot();
			}
			_shootTimer += FlxG.elapsed;
		}
		else
		{
			if (l < GameProperties.EnemyViewRange)
			{
				_hasSeenPlayer = true;
			}
		}
        super.update();
    }
	
	public override function shoot():Void
    {
        if (_shootTimer >= _shootTimerMax)
        {
            //var dAngle = FlxRandom.floatRanged(-GameProperties.PlayerWeaponMgSpreadInDegree, GameProperties.PlayerWeaponMgSpreadInDegree);
            var rad:Float = (angle) / 180 * Math.PI;
            var dx:Float = Math.cos(rad) * 7 + 5;
            var dy:Float = Math.sin(rad) * 7 + 7;
            
            var s:Shot = new Shot(x + dx, y + dy, angle + dAngle, ShotType.MgSmall, _state, false);
			s.setDamage(4, 1);
            _state.addShot(s);
            
            _shootTimer = 0;
        }
    }
    
}