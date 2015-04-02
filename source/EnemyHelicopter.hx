package ;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxVector;
import flash.display.BlendMode;
import flixel.FlxG;

/**
 * ...
 * @author Thunraz
 */
class EnemyHelicopter extends Enemy
{

    public function new(state:PlayState) 
    {
		super();
        type = EnemyType.Helicopter;
        _state = state;
        
        // ************
        // * tweak me *
        // ************
        var mainSprite:String = AssetPaths.enemyHelicopter__png;
        var shadowSprite:String = AssetPaths.enemyHelicopterShadow__png;
        var animationSpeed = 24;
        
        var mainAnimation = [0, 1, 2, 3];
        var shadowAnimation = [0, 1];
        _shadowDistance = 3;
        
        _health = _healthMax = GameProperties.EnemyHeliDefaultHealth;
        _shootTimer = _shootTimerMax = GameProperties.EnemyHeliShootInterval;
        isGround = false;
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
        
        
    }
    
	
	override public function update():Void 
    {
		var playerPos:FlxVector = _state.getNearestPlayer(new FlxPoint(x, y));
		var heliPos:FlxVector  = new FlxVector(x,y);
		
		var direction:FlxVector = new FlxVector(playerPos.x - heliPos.x,playerPos.y - heliPos.y);
		var l = direction.length;
		if (_hasSeenPlayer)
		{
			// drive towards player
			
			
			var targetAngle:Float = direction.degrees;
			var currentAngle:Float = angle;
			
			var angleDifference:Float = targetAngle - currentAngle;
			
			if (angleDifference > 0 && angleDifference >= GameProperties.EnemyHeliTurnSpeed)
			{
				angleDifference = GameProperties.EnemyHeliTurnSpeed;
			}
			else if (angleDifference <= 0 && angleDifference <= GameProperties.EnemyHeliTurnSpeed)
			{
				angleDifference = -GameProperties.EnemyHeliTurnSpeed;
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
				
				var tmp:Float = GameProperties.EnemyHeliMovementSpeed * FlxG.elapsed;
				
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
            var dAngle = FlxRandom.floatRanged(-GameProperties.PlayerWeaponMgSpreadInDegree, GameProperties.PlayerWeaponMgSpreadInDegree);
            var rad:Float = (angle) / 180 * Math.PI;
            var dx:Float = Math.cos(rad) * 7 + 5;
            var dy:Float = Math.sin(rad) * 7 + 7;
            
            var s:Shot = new Shot(x + dx, y + dy, angle + dAngle, ShotType.Mg, _state, -1);
			s.setDamage(GameProperties.EnemyHeliDamage, 1);
            _state.addShot(s);
            
            _shootTimer = 0;
        }
    }

	
	
}