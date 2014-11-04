package ;
import flixel.FlxObject;
import flixel.FlxSprite;
import flash.display.BlendMode;
import flixel.FlxG;

/**
 * ...
 * @author Thunraz
 */
class Enemy extends FlxObject
{
    public var type:EnemyType;
    
    private var _sprite:FlxSprite;
    private var _shadowSprite:FlxSprite;

    public function new(EnemyType type)
    {
        this.type = type;
        
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
                    animation = [0, 1];
                    shadowAnimation = [0];
                }
                break;
            case EnemyType.Helicopter:
                {
                    mainSprite = AssetPaths.enemyHelicopter__png;
                    shadowSprite = AssetPaths.enemyHelicopterShadow__png;
                    animation = [0];
                    shadowAnimation = [0];
                }
                break;
            case EnemyType.Soldier:
                {
                    mainSprite = AssetPaths.enemySoldier__png;
                    shadowSprite = AssetPaths.enemySoldierShadow__png;
                    animation = [0];
                    shadowAnimation = [0];
                }
                break;
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
}