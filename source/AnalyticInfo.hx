package ;

/**
 * ...
 * @author Laguna
 */
class AnalyticInfo
{
    public var _time : Float;
    public var _posX : Float;
    public var _posY : Float;
    public var _name : String;
    public var _comment : String;
    
    public function new(time : Float, posX : Float, posY : Float, name :String, comment:String) 
    {
        _time = time;
        _posX = posX;
        _posY = posY;
        _name = name;
        _comment = comment;
    }
    
    public function ToString () : String 
    {
        var str : String = _name + " Time: " + _time + " at Position ("  + _posX + " , " + _posY + ") " + _comment;
        
        return str;
    }
    
}