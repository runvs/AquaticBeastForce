package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxColorUtil;
import flixel.util.FlxVector;
import sys.io.File;

/**
 * ...
 * @author Thunraz
 */
class BriefingRoomState extends FlxState
{
    private var _briefingSprite:FlxSprite;
    private var _briefingText:FlxText;
    private var _briefingTextBackground:FlxSprite;
    private var _bubblePosition:FlxVector;
    private var _timeSinceStart = 0.0;
    
    private var _bubbleTimer = 2.5;
    private var _missionStrings = [];
    private var _missionStringIndex = 0;
    
    private var _nextState:FlxState;

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
        
        _briefingText = new FlxText();
        _briefingText.alignment = 'center';
        _briefingText.wordWrap = true;
        add(_briefingText);
    }
    
    public function init(nextState:FlxState, missionStringsLocation:String):Void
    {
        _nextState = nextState;
        _missionStrings = File.getContent(missionStringsLocation).split('\n');
    }
    
    override public function update():Void 
    {
        super.update();
        
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
            
            trace(_briefingText.fieldWidth);
            _missionStringIndex++;
        }
        
        if (_missionStringIndex < _missionStrings.length)
        {
            _briefingText.text = _missionStrings[_missionStringIndex];
            
            _bubblePosition.set(
                50 + Math.sin(_timeSinceStart * 2 + 4.2),
                20 + 2 * Math.sin(_timeSinceStart * 1.5)
            );
            _briefingText.setPosition(_bubblePosition.x, _bubblePosition.y);
            
            _briefingTextBackground.setGraphicSize(_briefingText.frameWidth, _briefingText.frameHeight);
            _briefingTextBackground.setPosition(_briefingText.x, _briefingText.y);
        }
        else
        {
            _briefingText.text = '';
            _briefingTextBackground.visible = false;
        }
        
        _bubbleTimer -= FlxG.elapsed;
        _timeSinceStart += FlxG.elapsed;
    }
    
}