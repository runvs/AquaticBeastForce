package ;

/**
 * ...
 * @author Thunraz
 */
class EnemyFactory
{
    public static function getEnemyByType(type:EnemyType, playState:PlayState):Enemy
    {
        switch(type)
        {
            case EnemyType.Tank:
                return new EnemyTank(playState);
            case EnemyType.Soldiers:
                return new EnemySoldier(playState);
            case EnemyType.Helicopter:
                return new EnemyHelicopter(playState);
        }
        
        throw "Unknown enemy type";
    }
    
    public static function getEnemyByString(type:String, playState:PlayState):Enemy
    {
        switch(type)
        {
            case "tank":
                return getEnemyByType(EnemyType.Tank, playState);
            case "soldiers":
                return getEnemyByType(EnemyType.Soldiers, playState);
            case "helicopter":
                return getEnemyByType(EnemyType.Helicopter, playState);
        }
        
        throw "Unknown enemy type";
    }
}