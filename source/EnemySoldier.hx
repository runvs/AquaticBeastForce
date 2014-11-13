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
    
}