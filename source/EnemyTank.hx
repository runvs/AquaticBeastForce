package ;
import flixel.FlxSprite;
import flixel.util.FlxVector;
import flash.display.BlendMode;
import flixel.FlxG;

/**
 * ...
 * @author Thunraz
 */
class EnemyTank extends Enemy
{
    
    public function new(state:PlayState) 
    {
        type = EnemyType.Tank;
        _state = state;
        
        // ************
        // * tweak me *
        // ************
        var mainSprite:String = AssetPaths.enemyTank__png;
        var shadowSprite:String = AssetPaths.enemyTankShadow__png;
        var animationSpeed = 12;
        
        var mainAnimation = [0, 1];
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
        // drive towards player
		var playerPos:FlxVector= new FlxVector(_state._player.x, _state._player.y);
		var tankPos:FlxVector  = new FlxVector(x,y);
		
		var direction:FlxVector = new FlxVector(playerPos.x - tankPos.x,playerPos.y - tankPos.y);
		var l = direction.length;
		
		var targetAngle:Float = direction.degrees;
		var currentAngle:Float = angle;
		
		var angleDifference:Float = targetAngle - currentAngle;
		
		if (angleDifference > 0 && angleDifference >= GameProperties.EnemyTankTurnSpeed)
		{
			angleDifference = GameProperties.EnemyTankTurnSpeed;
		}
		else if (angleDifference <= 0 && angleDifference <= GameProperties.EnemyTankTurnSpeed)
		{
			angleDifference = -GameProperties.EnemyTankTurnSpeed;
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
			
			var tmp:Float = GameProperties.EnemyTankMovementSpeed * FlxG.elapsed;
			
			velocity.x += direction.x * tmp;
			velocity.y += direction.y * tmp;
		}
		
				
		
		var angletoTurn = targetAngle - currentAngle;
		if ( Math.abs(angletoTurn) <= 1 && l <= 120)
		{
			shoot();
		}
		
		_shootTimer += FlxG.elapsed;
        
        super.update();
    }
    
}