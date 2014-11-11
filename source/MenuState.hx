package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import haxe.ds.Vector;
using flixel.util.FlxSpriteUtil;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	private var _playButton :FlxButton;
    private var _intro:FlxSprite;
    
	override public function create():Void
	{
		super.create();
        
        _intro = new FlxSprite();
        _intro.loadGraphic(AssetPaths.logo__png, true, 166, 144);
        _intro.animation.add('intro', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23], 10, false);
        _intro.animation.play('intro');
        add(_intro);
        
		_playButton = new FlxButton(35, 114, "", startGame);
        _playButton.loadGraphic(AssetPaths.playButton__png, false, 48, 21);
        _playButton.visible = false;
		//_playButton.screenCenter();
		
		add(_playButton);
	}
	
	public function startGame():Void
	{
		trace("switch to playstate");
		FlxG.switchState(new PlayState());
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
        _intro.update();
        if (_intro.animation.finished)
        {
            _playButton.visible = true;
        }
        
		super.update();
	}	
}