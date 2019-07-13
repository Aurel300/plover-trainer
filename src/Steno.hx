/**
  Stenography theory.
**/
class Steno {
  /**
    Order of keys on a Plover keyboard.
  **/
  public static final ORDER = "STKPWHRAO*EUFRPBLGTSDZ";
  
  /**
    Gets the position of keys of a stenographic chord.
    Returns an array of indices in the `ORDER` string.
    Example: `SKH` -> `[0, 2, 5]`
  **/
  public static function order(word:String):Array<Int> {
    var lastIndex = null;
    return [ for (key in word.split("")) {
      var next = ORDER.indexOf(key, lastIndex);
      if (next == -1) break;
      lastIndex = next;
    } ];
  }
}
