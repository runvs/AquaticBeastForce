package ;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxVector;
import flash.display.BlendMode;
import flixel.FlxG;

/**
 * ...
 * @author Thunraz
 */
class EnemySam extends Enemy
{
    
    public function new(state:PlayState) 
    {
    	super();

        type = EnemyType.Sam;
        _state = state;
        
        // ************
        // * tweak me *
        // ************
        var mainSprite:String = AssetPaths.enemySam__png;
        var shadowSprite:String = AssetPaths.enemySamShadow__png;
        var animationSpeed = 12;
        
        var mainAnimation = [0];
        var shadowAnimation = [0];
        _shadowDistance = 1;
        
        _health = _healthMax = GameProperties.EnemySamDefaultHealth;
        _shootTimer = _shootTimerMax = GameProperties.EnemySamShootInterval;
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
    }
    
    override public function update():Void 
    {
		var playerPos:FlxVector = _state.getNearestPlayer(new FlxPoint(x, y));
		var tankPos:FlxVector   = new FlxVector(x,y);
		
		var direction:FlxVector = new FlxVector(playerPos.x - tankPos.x,playerPos.y - tankPos.y);
		var l = direction.length;
		if (_hasSeenPlayer)
		{
			// Turn towards player
			var targetAngle:Float = direction.degrees;
			var currentAngle:Float = angle;
			
			var angleDifference:Float = targetAngle - currentAngle;
			if (angleDifference > 0 && angleDifference >= GameProperties.EnemySamTurnSpeed)
			{
				angleDifference = GameProperties.EnemySamTurnSpeed;
			}
			else if (angleDifference <= 0 && angleDifference <= GameProperties.EnemySamTurnSpeed)
			{
				angleDifference = -GameProperties.EnemySamTurnSpeed;
			}
			currentAngle += angleDifference;
			
			var rad:Float = currentAngle / 180 * Math.PI;
			var dx:Float = Math.cos(rad);
			var dy:Float = Math.sin(rad);
			
			direction = new FlxVector(dx, dy);
			angle = direction.degrees;
			
			var angleToTurn = targetAngle - currentAngle;
			if (Math.abs(angleToTurn) <= 1 && l <= 120)
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
			//trace ("shoot (SAM)");
            //var dAngle = FlxRandom.floatRanged(-GameProperties.PlayerWeaponMgSpreadInDegree, GameProperties.PlayerWeaponMgSpreadInDegree);
            var rad:Float = (angle) / 180 * Math.PI;
            var dx:Float = Math.cos(rad) * 7 + 5;
            var dy:Float = Math.sin(rad) * 7 + 7;
            
            var s:Shot = new Shot(x + dx, y + dy, angle, ShotType.RocketAirGround, _state, -1);
			s.setDamage(GameProperties.EnemySamDamage, 1);
            _state.addShot(s);
            
            _shootTimer = 0;
        }
    }
    
}