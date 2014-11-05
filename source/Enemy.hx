package ;
import flixel.FlxObject;
import flixel.FlxSprite;
import flash.display.BlendMode;
import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.util.FlxVector;

/**
 * ...
 * @author Thunraz
 */
class Enemy extends FlxObject
{
    public var type:EnemyType;
    
    private var _sprite:FlxSprite;
    private var _shadowSprite:FlxSprite;
	private var _shadowDistance:Float;
	private var _state:PlayState;

    public function new(type:EnemyType, state:PlayState )
    {
        this.type = type;
        _state = state;
		
		
        var mainSprite:String;
        var shadowSprite:String;
        var mainAnimation = [];
        var shadowAnimation = [];
        var animationSpeed = 12;
        
        switch(this.type)
        {
            case EnemyType.Tank:
                {
                    mainSprite = AssetPaths.enemyTank__png;
                    shadowSprite = AssetPaths.enemyTankShadow__png;
                    mainAnimation = [0, 1];
                    shadowAnimation = [0];
					_shadowDistance = 1;
                };
            case EnemyType.Helicopter:
                {
                    mainSprite = AssetPaths.enemyHelicopter__png;
                    shadowSprite = AssetPaths.enemyHelicopterShadow__png;
                    mainAnimation = [0];
                    shadowAnimation = [0];
					_shadowDistance = 3;
                };
            case EnemyType.Soldiers:
                {
                    mainSprite = AssetPaths.enemySoldier__png;
                    shadowSprite = AssetPaths.enemySoldierShadow__png;
                    mainAnimation = [0];
                    shadowAnimation = [0];
					_shadowDistance = 1;
                };
        }
        
        // Load sprite for the enemy
        _sprite = new FlxSprite();
        _sprite.loadGraphic(mainSprite, true, 16, 16);
        _sprite.animation.add("base", mainAnimation, animationSpeed, true);
        _sprite.animation.play("base");
        
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
		_sprite.setPosition(x, y);
		_shadowSprite.setPosition(x + _shadowDistance, y + _shadowDistance);
		
		_sprite.angle = angle;
		_shadowSprite.angle = angle;
		
		_sprite.update();
		_shadowSprite.update();
		
		
		if (type == EnemyType.Tank)
		{
			updateTank();
		}
		
		velocity.x *= 0.96;
		velocity.y *= 0.96;
		
		
		super.update();
	}
	
	private function updateTank():Void
	{
		// drive towards player
		var playerPos:FlxVector= new FlxVector(_state._player.x, _state._player.y);
		var tankPos:FlxVector  = new FlxVector(x,y);
		
		var direction:FlxVector = new FlxVector(playerPos.x - tankPos.x,playerPos.y - tankPos.y);
		var l = direction.length;
		
//		angle = direction.degrees;
		
		var targetAngle:Float = direction.degrees;
		var currentAngle:Float = angle;
		
		var angleDifference:Float= targetAngle - currentAngle;
		
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
		
	}
	
	
	
	 override public function draw():Void 
    {
		_shadowSprite.draw();
		_sprite.draw();
		super.draw();
	}
}