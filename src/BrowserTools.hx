import js.Browser;
import js.html.*;

/**
  Static extension for browser- and element-related actions.
**/
class BrowserTools {
  public static function id(i:String):Element {
    return Browser.document.getElementById(i);
  }

  public static function input(el:Element):InputElement {
    return (cast el:InputElement);
  }

  public static function els(nl:NodeList):Array<Element> {
    return [ for (i in 0...nl.length) cast nl[i] ];
  }

  public static function clAdd(el:Element, cls:String):Void {
    el.classList.add(cls);
  }

  public static function clRemove(el:Element, cls:String):Void {
    el.classList.remove(cls);
  }

  public static function qs(?el:Element, sel:String):Element {
    if (el == null)
      return Browser.document.querySelector(sel);
    return el.querySelector(sel);
  }

  public static function qsa(?el:Element, sel:String):Array<Element> {
    if (el == null)
      return els(Browser.document.querySelectorAll(sel));
    return els(el.querySelectorAll(sel));
  }
}
