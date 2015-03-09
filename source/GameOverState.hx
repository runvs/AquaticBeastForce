package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxVector;
import flixel.input.gamepad.XboxButtonID;

/**
 * ...
 * @author Thunraz
 */
class GameOverState extends FlxState
{
    private var _timeSinceStart:Float = 0.0;
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
        _gameOverText.fieldWidth = 100;
        add(_gameOverText);

        if(_winning)
        {
            _gameOverText.text = 'You won.\nFinal score: ' + Player.TotalPoints;
        }
        else
        {
            _gameOverText.text = 'You lost.\nFinal score: ' + Player.TotalPoints;
        }

        _gameOverText.setPosition(50, 20);
    }

    override public function destroy():Void
    {
        _gameOverText.destroy();
    }
    
    override public function update():Void 
    {
        super.update();

        _timeSinceStart += FlxG.elapsed;

        var vector = new FlxVector();
        vector.set(
            50 + Math.sin(_timeSinceStart * 2 + 4.2),
            20 + 2 * Math.sin(_timeSinceStart * 1.5)
        );
        _gameOverText.setPosition(vector.x, vector.y);
        
        if (_timeSinceStart >= 0.5 && (FlxG.keys.justPressed.ANY || FlxG.mouse.justPressed))
        {
            FlxG.switchState(new MenuState());
        }
		var _gamePad = FlxG.gamepads.lastActive;
		if (_timeSinceStart >= 0.5 && _gamePad != null) 
		{
			if (_gamePad.justReleased(XboxButtonID.DPAD_LEFT) || _gamePad.justReleased(XboxButtonID.DPAD_RIGHT) ||
			_gamePad.justReleased(XboxButtonID.DPAD_UP) || _gamePad.justReleased(XboxButtonID.DPAD_DOWN))
			{
				FlxG.switchState(new MenuState());
			}
		}
    }
    
}