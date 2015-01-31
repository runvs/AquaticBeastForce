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

    override public function create():Void
    {
        super.create();

        _gameOverText = new FlxText();
        _gameOverText.alignment = 'center';
        add(_gameOverText);

        trace('Game Over!');
    }

    public function init(winning:Bool):Void
    {
        if(winning)
        {
            _gameOverText.text = '';
        }
        else
        {
            _gameOverText.text = 'Game Over! You scored: ' + Player.TotalPoints;
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
        
        if (_ignoreInputTimer <= 0.0 && FlxG.keys.justPressed.ANY)
        {
            FlxG.switchState(new MenuState());
        }
    }
    
}