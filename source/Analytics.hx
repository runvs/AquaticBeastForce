package ;
import flixel.FlxG;
import flixel.group.FlxTypedGroup;
import haxe.CallStack;
import haxe.ds.HashMap;
import haxe.ds.Vector;
import sys.io.File;

/**
 * ...
 * @author Laguna
 */

 // This static class will track any analytics that could be handy for understanding the player's behaviour
class Analytics
{
    private static var _time : Float;   // a clock in this class
    
    private static var _allEvents : List<AnalyticInfo> = new List<AnalyticInfo>();
    
    private static var _enemiesDestroyed : List<AnalyticInfo> = new List<AnalyticInfo>();
    private static var _enemyTanksDestroyed : List<AnalyticInfo> = new List<AnalyticInfo>();
    private static var _enemyHelicoptersDestroyed : List<AnalyticInfo> = new List<AnalyticInfo>();
    private static var _enemySamsDestroyed : List<AnalyticInfo> = new List<AnalyticInfo>();
    private static var _enemySoldiersDestroyed : List<AnalyticInfo> = new List<AnalyticInfo>();
    
    private static var _destroyableDestroyed : List<AnalyticInfo> = new List<AnalyticInfo>();
    private static var _pointsChanged : List<AnalyticInfo> = new List<AnalyticInfo>();
    
    public function new() 
    {
    }
    
    public static function start()
    {
        _time = 0;
    }
 
    public static function update()
    {
        _time += FlxG.elapsed;
    }
    
    
    public static function LogEnemyDestroyed (e:Enemy)
    {
        var general : AnalyticInfo = new AnalyticInfo(_time, e.x, e.y, "Enemy Destroyed", "Type " + e.type + " : " +e.name + " lastHit :" + e.getLastHit() );
        _allEvents.add(general);
        _enemiesDestroyed.add(general);
        if (e.type == EnemyType.Helicopter)
        {
            _enemyHelicoptersDestroyed.add(general);
        }
        else if (e.type == EnemyType.Tank)
        {
            _enemyTanksDestroyed.add(general);
        }
        else if (e.type == EnemyType.Soldiers)
        {
            _enemySoldiersDestroyed.add(general);
        }
        else if (e.type == EnemyType.Sam)
        {
            _enemySamsDestroyed.add(general);
        }
    }
    
    public static function LogDestroyableDestroyed (d:DestroyableObject)
    {
        var general : AnalyticInfo = new AnalyticInfo(_time, d.x, d.y, "Destroyable destroyed", "Type: " + d._type + ": " + d.name + " lastHit :" + d.getLastHit());
        _allEvents.add(general);
        _destroyableDestroyed.add(general);
    }
    
    public static function LogPoints ( p : Player, pID : Int , points : Int )
    {
        
        var general : AnalyticInfo = new AnalyticInfo(_time, p.x, p.y, "Points Changed for Player " + pID + ": + "  + points, "");
        _allEvents.add(general);
        _pointsChanged.add(general);
    }
    
    
    
    public static function SaveAnalytics (fileName :String ) : Void 
    {
        var fout = File.write(fileName, false);
        
        while (!_allEvents.isEmpty())
        {
            fout.writeString(Std.string(_allEvents.pop()) + "\n");
            
        }
        fout.close();
    }
    
    
    public static function getNumberOfDeadEnemies () : Int 
    {
        return _enemiesDestroyed.length;
    }
    
    public static function getNumberOfDeadEnemyTanks () : Int 
    {
        return _enemyTanksDestroyed.length;
    }
    
    public static function getNumberOfDeadEnemyHelicopters () : Int 
    {
        return _enemyHelicoptersDestroyed.length;
    }
    public static function getNumberOfDeadEnemySams () : Int 
    {
        return _enemySamsDestroyed.length;
    }
    public static function getNumberOfDeadEnemySoldiers () : Int 
    {
        return _enemySoldiersDestroyed.length;
    }
    
    public static function getNumberOfDestroeyedDestroyables () : Int 
    {
        return _destroyableDestroyed.length;
    }
}