package ;

import flixel.FlxG;
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

	private var _costRepair:Int = 15;
	private var _costArmor:Int = 12;
	private var _costFirerate:Int = 10;
	private var _costSpecial:Int = 30;
	
	private var _specialID : Int = 0;
	
	private var _hasBoughtAAR : Bool = false;
	private var _hasBoughtAGR : Bool = false;
	private var _hasBoughtAutoTurret : Bool = false;
	private var _hasBoughtBFG : Bool = false;
	
	
	
	
	public function new(state:PlayState) 
	{
		super();
		_state = state;
		_background = new FlxSprite();
		_background.makeGraphic(120, 100, FlxColorUtil.makeFromARGB(1.0, 8, 47, 27));
		_background.scrollFactor.set();
		_background.origin.set();
		_background.setPosition(20, 22);
		
		_btnRepair  = new FlxButton (40, 11 + 10, "Repair", DoRepair);
		_btnArmor = new FlxButton (40, 11 + 30, "Armor +", DoArmor);
		_btnFirerate = new FlxButton (40, 11 + 50, "Firerate +", DoRate);
		_btnSpecBuy = new FlxButton (40, 11 + 70, "Turret", DoSpecial);
		_btnSpecNext = new FlxButton (120, 11 + 70, "[>]", SpecialNext);
		_btnSpecNext.loadGraphic(AssetPaths.button__png, true, 20, 20);
		_btnSpecPrev = new FlxButton (20, 11 + 70, "[<]", SpecialPrev);
		_btnSpecPrev.loadGraphic(AssetPaths.button__png, true, 20, 20);
		_btnQuit = new FlxButton (40, 11 + 90, "[Q]uit", Quit);
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
			_state._player.ChangePoints( - _costArmor);
			_state._player.SetMaxHealth(_state._player._health + GameProperties.UpgradeHealthAdd);
			_costArmor *= 2;
		}
	}
	private function DoRate () : Void 
	{
		if (_state._player.HasEnoughPoints(_costFirerate))
		{
			_state._player.ChangePoints( - _costRepair);
			_state._player._weaponSystems._mgFireTimeMax -= 0.025;
			_costFirerate *= 2;
		}
	}
	
	private function DoSpecial () : Void 
	{
		if (_state._player.HasEnoughPoints(_costSpecial))
		{
			if (_specialID == 0)
			{
				if (!_hasBoughtAutoTurret)
				{
					_state._player.ChangePoints( - _costSpecial);
				}
				_state._player._weaponSystems._hasAutoTurret = true;
				_state._player._weaponSystems._hasAirAirRockets = false;
				_state._player._weaponSystems._hasAirGroundRockets= false;
				_state._player._weaponSystems._hasBFG = false;
				_hasBoughtAutoTurret = true;
				

			}
			else if (_specialID == 1)
			{
				
				if (!_hasBoughtAAR)
				{
					_state._player.ChangePoints( - _costSpecial);
				}
				_state._player._weaponSystems._hasAutoTurret = false;
				_state._player._weaponSystems._hasAirAirRockets = true;
				_state._player._weaponSystems._hasAirGroundRockets= false;
				_state._player._weaponSystems._hasBFG = false;
				_hasBoughtAAR = true;
			}
			else if (_specialID == 2)
			{
				
				if (!_hasBoughtAGR)
				{
					_state._player.ChangePoints( - _costSpecial);
				}
				_state._player._weaponSystems._hasAutoTurret = false;
				_state._player._weaponSystems._hasAirAirRockets = false;
				_state._player._weaponSystems._hasAirGroundRockets= true;
				_state._player._weaponSystems._hasBFG = false;
				_hasBoughtAGR = true;
			}
			else if (_specialID == 3)
			{
				
				if (!_hasBoughtBFG)
				{
					_state._player.ChangePoints( - _costSpecial);
				}
				_state._player._weaponSystems._hasAutoTurret = false;
				_state._player._weaponSystems._hasAirAirRockets = false;
				_state._player._weaponSystems._hasAirGroundRockets= false;
				_state._player._weaponSystems._hasBFG = true;
				_hasBoughtBFG = true;
			}		
		}
	}
	private function SpecialNext () : Void 
	{
		_specialID++;
		if (_specialID > 3)
		{
			_specialID = 0;
		}
	}
	private function SpecialPrev () : Void 
	{
		_specialID--;
		if (_specialID < 0)
		{
			_specialID = 3;
		}
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
		
		if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.A)
		{
			SpecialPrev();
		}
		else if(FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.D)
		{
			SpecialNext();
		}
		if ( FlxG.keys.justPressed.R)
		{
			DoRepair();
		}
		if ( FlxG.keys.justPressed.E)
		{
			DoRate();
		}
		if ( FlxG.keys.justPressed.M)
		{
			DoArmor();
		}
		if ( FlxG.keys.justPressed.S)
		{
			DoSpecial();
		}
		if ( FlxG.keys.justPressed.Q)
		{
			Quit();
		}
		
		_btnRepair.text = "[R]epair " + Std.string(_costRepair);
		_btnFirerate.text = "Rat[e] " + Std.string(_costFirerate);
		if (_specialID == 0)
		{
			if (!_hasBoughtAutoTurret)
			{
				_btnSpecBuy.text = "[S]Turret " + Std.string(_costSpecial);
			}
			else
			{
				_btnSpecBuy.text = "Turret " + "Bought";
			}
		}
		else if (_specialID == 1)
		{
			
			if (!_hasBoughtAAR)
			{
				_btnSpecBuy.text = "[S]AAM " + Std.string(_costSpecial);
			}
			else
			{
				_btnSpecBuy.text = "[S]AAM " + "Bought";
			}
		}
		else if (_specialID == 2)
		{
			
			if (!_hasBoughtAGR)
			{
				_btnSpecBuy.text = "[S]AGM " + Std.string(_costSpecial);
			}
			else
			{
				_btnSpecBuy.text = "[S]AGM " + "Bought";
			}
		}
		else if (_specialID == 3)
		{
			
			if (!_hasBoughtBFG)
			{
				_btnSpecBuy.text = "[S]BFG " + Std.string(_costSpecial);
			}
			else
			{
				_btnSpecBuy.text = "[S]BFG " + "Bought";
			}
		}
		_btnArmor.text = "Ar[m]or" + Std.string(_costArmor);
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