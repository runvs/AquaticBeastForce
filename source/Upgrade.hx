package ;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.util.FlxColorUtil;

/**
 * ...
 * @author 
 */
class Upgrade extends FlxObject
{
	private var _state : PlayState;
	
	private var _background : FlxSprite;
	
	private var _btnRepair : FlxButton;
	private var _btnArmor : FlxButton;
	private var _btnFirerate : FlxButton;
	private var _btnSpecBuy : FlxButton;
	private var _btnSpecNext : FlxButton;
	private var _btnSpecPrev : FlxButton;
	private var _btnQuit : FlxButton;

	private var _costRepair:Int = 10;
	private var _costArmor:Int = 10;
	private var _costFirerate:Int = 10;
	private var _costSpecial:Int = 10;
	
	
	public function new(state:PlayState) 
	{
		super();
		_state = state;
		_background = new FlxSprite();
		_background.makeGraphic(100, 100, FlxColorUtil.makeFromARGB(1.0, 8, 47, 27));
		_background.scrollFactor.set();
		_background.origin.set();
		_background.setPosition(30, 22);
		
		_btnRepair  = new FlxButton (40, 11 + 10, "Repair", DoRepair);
		_btnArmor = new FlxButton (40, 11 + 30, "Armor +", DoArmor);
		_btnFirerate = new FlxButton (40, 11 + 50, "Firerate +", DoRate);
		_btnSpecBuy = new FlxButton (40, 11 + 70, "Special", DoSpecial);
		_btnSpecNext = new FlxButton (110, 11 + 70, ">", SpecialNext);
		_btnSpecNext.loadGraphic(AssetPaths.button__png, true, 20, 20);
		_btnSpecPrev = new FlxButton (30, 11 + 70, "<", SpecialPrev);
		_btnSpecPrev.loadGraphic(AssetPaths.button__png, true, 20, 20);
		_btnQuit = new FlxButton (40, 11 + 90, "Quit", Quit);
	}
	
	private function DoRepair () : Void 
	{
		if (_state._player.HasEnoughPoints(_costRepair))
		{
			_state._player.ChangePoints( - _costRepair);
			_state._player.repair();
		}
	}
	private function DoArmor () : Void 
	{
		if (_state._player.HasEnoughPoints(_costArmor))
		{
			_state._player.ChangePoints( - _costRepair);
		}
	}
	private function DoRate () : Void 
	{
		if (_state._player.HasEnoughPoints(_costFirerate))
		{
			_state._player.ChangePoints( - _costRepair);
		}
	}
	
	private function DoSpecial () : Void 
	{
		if (_state._player.HasEnoughPoints(_costSpecial))
		{
			_state._player.ChangePoints( - _costRepair);
		}
	}
	private function SpecialNext () : Void 
	{
		
	}
	private function SpecialPrev () : Void 
	{
		
	}
	private function Quit() : Void 
	{
		alive = false;
	}
	
	
	
	override public function update():Void 
	{
		_background.update();
		
		_btnRepair.update();
		_btnArmor.update();
		_btnFirerate.update();
		_btnSpecBuy.update();
		_btnSpecNext.update();
		_btnSpecPrev.update();
		_btnQuit.update();
	}
	override public function draw():Void 
	{
		_background.draw();
		
		_btnRepair.draw();
		_btnArmor.draw();
		_btnFirerate.draw();
		_btnSpecBuy.draw();
		_btnSpecNext.draw();
		_btnSpecPrev.draw();
		_btnQuit.draw();
	}
	
}