package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
/**
 * ...
 * @author Thunraz
 */
class GameOverState extends FlxState
{
    private var _ignoreInputTimer:Float = 0.5;
    private var _gameOverText:FlxText;
    private var _winning:Bool;

    override public function new(winning:Bool):Void
    {
        super();

        _winning = winning;
    }

    override public function create():Void
    {
        _gameOverText = new FlxText();
        _gameOverText.alignment = 'center';
        add(_gameOverText);

        if(_winning)
        {
            _gameOverText.text = 'You won. Your score: ' + Player.TotalPoints;
        }
        else
        {
            _gameOverText.text = 'You lost. Your score: ' + Player.TotalPoints;
        }
    }

    override public function destroy():Void
    {
        _gameOverText.destroy();
    }
    
    override public function update():Void 
    {
        super.update();

        _ignoreInputTimer -= FlxG.elapsed;
        
        if (_ignoreInputTimer <= 0.0 && (FlxG.keys.justPressed.ANY || FlxG.mouse.justPressed))
        {
            FlxG.switchState(new MenuState());
        }
    }
    
}