package ;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColorUtil;
import flixel.util.FlxTimer;

/**
 * ...
 * @author 
 */
class DisplayAchievmentImpl extends FlxObject implements IDisplayAchievment
{
	
	private var _backgroundSprite : FlxSprite;
	private var _text : FlxText;

	public function new() 
	{
		super();
		_backgroundSprite = new FlxSprite();
		_backgroundSprite.makeGraphic(140, 20, FlxColorUtil.makeFromARGB(1.0, 20, 53, 79));
		_backgroundSprite.scrollFactor.set();
		_backgroundSprite.origin.set();
		_backgroundSprite.x = 13;
		_backgroundSprite.y = -20;
		
		_text = new FlxText(15, -20, 136, "");
		_text.scrollFactor.set();
		_text.origin.set();
	}
	
	public override function draw () : Void
	{
		_backgroundSprite.draw();
		_text.draw();
	}
	
	public override function update () : Void
	{
		_backgroundSprite.update();
		_text.update();
	}
	
	/* INTERFACE IDisplayAchievment */
	
	public function DisplayAchievmentMessage(s:String):Void 
	{
		var t : String = "Achievment Unlocked: " + s;
		trace(t);
		_text.text = t;
		_backgroundSprite.setPosition(13, -20);
		_text.setPosition(15, -20);
		
		FlxTween.tween(_backgroundSprite, { y : 0 }, 0.5 );
		FlxTween.tween(_text, { y : 0 }, 0.5 );
	
		var t: FlxTimer = new FlxTimer(1.5, function (t:FlxTimer) : Void { _backgroundSprite.y = -20; _text.y = -20; } );
	}
	
}