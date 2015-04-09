package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxColorUtil;
import flixel.util.FlxVector;
import openfl.Assets;
import flixel.input.gamepad.XboxButtonID;

/**
 * ...
 * @author Thunraz
 */
class BriefingRoomState extends FlxState
{
    private var _briefingSprite:FlxSprite;
    private var _briefingText1:FlxText;
	private var _briefingText2:FlxText;
    private var _briefingTextBackground:FlxSprite;
    private var _bubblePosition:FlxVector;
    private var _timeSinceStart = 0.0;
    
    private var _bubbleTimer = 2.5;
    private var _missionStrings = [];
    private var _missionStringIndex = 0;
    
    private var _nextState:FlxState;
	
	private var _vignette : FlxSprite;

    override public function create():Void
    {
        super.create();
        
        _bubblePosition = new FlxVector();
        
        _briefingSprite = new FlxSprite();
        _briefingSprite.loadGraphic(AssetPaths.briefingRoom__png, true, 160, 144);
        add(_briefingSprite);
        
        _briefingTextBackground = new FlxSprite();
        _briefingTextBackground.makeGraphic(16, 16, 0xff032004);
        _briefingTextBackground.origin.x = 0;
        _briefingTextBackground.origin.y = 0;
        _briefingTextBackground.alpha = 0.6;
        add(_briefingTextBackground);
        
        _briefingText1 = new FlxText();
        _briefingText1.alignment = 'center';
        _briefingText1.wordWrap = true;
        _briefingText1.fieldWidth = 100;
		_briefingText1.color = FlxColorUtil.makeFromARGB(1.0, 3, 32, 4);
        add(_briefingText1);
		
		_briefingText2 = new FlxText();
        _briefingText2.alignment = 'center';
        _briefingText2.wordWrap = true;
        _briefingText2.fieldWidth = 100;
		_briefingText2.color = FlxColorUtil.makeFromARGB(1.0, 215, 238, 218);
        add(_briefingText2);
		
		_vignette = new FlxSprite();
		_vignette.loadGraphic(AssetPaths.Vignette__png, false, 160, 144);
		_vignette.scrollFactor.set();
		_vignette.origin.set();
		_vignette.alpha = 0.4;
		add(_vignette);
    }
    
    public function init(nextState:FlxState, missionStringsLocation:String):Void
    {
        _nextState = nextState;
        _missionStrings = Assets.getText("assets/data/missionBriefing1.txt").split('\n');
    }
    
    override public function update():Void 
    {
        super.update();
        
        if (FlxG.mouse.justReleased)
        {
            _bubbleTimer = 0;
        }
		var _gamePad = FlxG.gamepads.lastActive;
		if (_gamePad != null) 
		{
			if (_gamePad.justReleased(XboxButtonID.DPAD_LEFT) || _gamePad.justReleased(XboxButtonID.DPAD_RIGHT) ||
			_gamePad.justReleased(XboxButtonID.DPAD_UP) || _gamePad.justReleased(XboxButtonID.DPAD_DOWN))
			{
				_bubbleTimer = 0;
			}
		}
        
        if (_bubbleTimer <= 0)
        {
            // Switch to the next state
            if (_missionStringIndex >= _missionStrings.length)
            {
                if (_nextState != null)
                {
                    FlxG.switchState(_nextState);
                }
                else
                {
                    FlxG.switchState(new MenuState());
                }
            }
            
            _bubbleTimer += 2.5;

            _missionStringIndex++;
        }
        
        if (_missionStringIndex < _missionStrings.length)
        {
            _briefingText1.text = _missionStrings[_missionStringIndex];
			_briefingText2.text = _missionStrings[_missionStringIndex];
            
            _bubblePosition.set(
                30 + Math.sin(_timeSinceStart * 2 + 4.2),
                20 + 2 * Math.sin(_timeSinceStart * 1.5)
            );
            _briefingText1.setPosition(_bubblePosition.x-1, _bubblePosition.y-1);
			_briefingText2.setPosition(_bubblePosition.x, _bubblePosition.y);
            
            _briefingTextBackground.setGraphicSize(_briefingText1.frameWidth, _briefingText1.frameHeight);
            _briefingTextBackground.setPosition(_briefingText1.x, _briefingText1.y);
        }
        else
        {
            _briefingText1.text = '';
			_briefingText2.text = '';
            _briefingTextBackground.visible = false;
        }
        
        _bubbleTimer -= FlxG.elapsed;
        _timeSinceStart += FlxG.elapsed;
    }
    
}