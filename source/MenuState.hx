package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import haxe.ds.Vector;
using flixel.util.FlxSpriteUtil;
import flixel.input.gamepad.XboxButtonID;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	private var _playButton:FlxButton;
	private var _helpButton:FlxButton;

    private var _splash:FlxSprite;
    private var _intro:FlxSprite;
    private var _helpScreen:FlxSprite;
	private var _vignette:FlxSprite;

	private var _helpShown:Bool = false;
    
	override public function create():Void
	{
		super.create();
        
        _splash = new FlxSprite();
        _splash.loadGraphic(AssetPaths.runvs_splash__png, true, 160, 144);
        _splash.animation.add(
            'intro',
            [
                0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
                25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46
            ],
            20,
            false
        );
        _splash.animation.play('intro');
        add(_splash);
        
        _intro = new FlxSprite();
        _intro.loadGraphic(AssetPaths.logo__png, true, 166, 144);
        _intro.animation.add('intro', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23], 10, false);
        _intro.visible = false;
        add(_intro);
        
		_playButton = new FlxButton(35, 114, "", startGame);
        _playButton.loadGraphic(AssetPaths.playButton__png, true, 48, 21);
        _playButton.animation.add('idle', [0]);
        _playButton.animation.add('hover', [1]);
        _playButton.onOver.callback = onOverPlayButton;
        _playButton.onOut.callback = onOutPlayButton;
        _playButton.visible = false;
        
		_helpButton = new FlxButton(92, 114, "", showHelp);
        _helpButton.loadGraphic(AssetPaths.helpButton__png, true, 48, 21);
        _helpButton.animation.add('idle', [0]);
        _helpButton.animation.add('hover', [1]);
        _helpButton.onOver.callback = onOverHelpButton;
        _helpButton.onOut.callback = onOutHelpButton;
        _helpButton.visible = false;

        _helpScreen = new FlxSprite();
        _helpScreen.loadGraphic(AssetPaths.help__png, false, 160, 144);
        _helpScreen.scrollFactor.set();
        _helpScreen.origin.set();
        _helpScreen.visible = false;
		
		_vignette = new FlxSprite();
		_vignette.loadGraphic(AssetPaths.Vignette__png, false, 160, 144);
		_vignette.scrollFactor.set();
		_vignette.origin.set();
		_vignette.alpha = 0.4;
		
		add(_playButton);
		add(_helpButton);

		add(_helpScreen);
		add(_vignette);

		FlxG.sound.playMusic(AssetPaths.ABF_OST__ogg, 1.0, true);
	}
	
	public function startGame():Void
	{
        var state = new BriefingRoomState();
		var ps : PlayState = new PlayState(false);
        state.init(ps, AssetPaths.missionBriefing1__txt);
        
		FlxG.switchState(state);
	}

	public function showHelp():Void
	{
			_helpShown = true;
	}
    
    public function onOutPlayButton():Void
    {
        _playButton.animation.play('idle');
    }
    
    public function onOverPlayButton():Void
    {
        _playButton.animation.play('hover');
    }
    
    public function onOutHelpButton():Void
    {
        _helpButton.animation.play('idle');
    }
    
    public function onOverHelpButton():Void
    {
        _helpButton.animation.play('hover');
    }
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function draw():Void
	{
		super.draw();

		if(_helpShown)
		{
			_helpScreen.draw();
		}
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
        _splash.update();
        
        if (_splash.animation.finished && !_intro.visible)
        {
            _intro.animation.play('intro');
            _intro.visible = true;
        }
        
        _intro.update();
        if (_splash.animation.finished && _intro.animation.finished)
        {
            _playButton.visible = true;
            _helpButton.visible = true;
			
			var _gamePad = FlxG.gamepads.lastActive;
			if (_gamePad != null) 
			{
				if (_gamePad.pressed(XboxButtonID.DPAD_LEFT) || _gamePad.pressed(XboxButtonID.DPAD_RIGHT) ||
				_gamePad.pressed(XboxButtonID.DPAD_UP) || _gamePad.pressed(XboxButtonID.DPAD_DOWN))
				{
					startGame();
				}
			}
			
        }

        if(_helpShown)
        {
        	if(FlxG.keys.justPressed.ANY)
        	{
        		_helpShown = false;
        	}
        }
        
		super.update();
	}	
}