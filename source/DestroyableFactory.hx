package;

import flixel.util.FlxVector;

/**
 * ...
 * @author Thunraz
 */
class DestroyableFactory
{
    public static function getDestroyableByType(x:Float, y:Float, type:DestroyableType, playState:PlayState):DestroyableObject
    {
        switch(type)
        {
            case DestroyableType.Barrel:
                return new DestroyableBarrel(x, y, playState, getSize(type), getScale(type), getHealth(type));
            case DestroyableType.FuelTank:
                return new DestroyableFuelTank(x, y, playState, getSize(type), getScale(type), getHealth(type));
            case DestroyableType.Radar:
                return new DestroyableRadar(x, y, playState, getSize(type), getScale(type), getHealth(type));
            case DestroyableType.Tent:
                return new DestroyableTent(x, y, playState, getSize(type), getScale(type), getHealth(type));
            case DestroyableType.Tower:
                return new DestroyableTower(x, y, playState, getSize(type), getScale(type), getHealth(type));
        }
        
        throw "Unknown destroyable type";
    }
    
    public static function getDestroyableByString(x:Float, y:Float, type:String, playState:PlayState):DestroyableObject
    {
        switch(type)
        {
            case "barrel":
                return getDestroyableByType(x, y, DestroyableType.Barrel,   playState);
            case "fueltank":
                return getDestroyableByType(x, y, DestroyableType.FuelTank, playState);
            case "radar":
                return getDestroyableByType(x, y, DestroyableType.Radar,    playState);
            case "tent":
                return getDestroyableByType(x, y, DestroyableType.Tent,     playState);
            case "tower":
                return getDestroyableByType(x, y, DestroyableType.Tower,    playState);
        }
        
        throw "Unknown destroyable type";
    }
    
    private static function getHealth(type:DestroyableType):Float
    {
        switch(type)
        {
            case DestroyableType.Barrel:
                return 5;
            case DestroyableType.FuelTank:
                return 25;
            case DestroyableType.Radar:
                return 10;
            case DestroyableType.Tent:
                return 8;
            case DestroyableType.Tower:
                return 12;
            default:
                return 1;
        }
    }

    private static function getScale(type:DestroyableType):FlxVector
    {
        switch(type)
        {
            case DestroyableType.Barrel:
                return new FlxVector( 8,  8);
            case DestroyableType.FuelTank:
                return new FlxVector(24, 24);
            case DestroyableType.Tent:
                return new FlxVector(32, 16);
            default:
                return new FlxVector(16, 16);
        }
    }

    private static function getSize(type:DestroyableType):FlxVector
    {
        switch(type)
        {
            case DestroyableType.Barrel:
                return new FlxVector(16, 16);
            case DestroyableType.FuelTank:
                return new FlxVector(24, 24);
            case DestroyableType.Tent:
                return new FlxVector(32, 16);
            default:
                return new FlxVector(16, 16);
        }
    }
    
}