package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;

class Cursor extends Entity {

  private var cursorArrow:Text;
  private var cursor:Entity;
  public var cursorItem:Int = 0;
  private var fade:Bool;

  public function new () {
    cursorItem = 0;

    cursorArrow = new Text(">");
    cursorArrow.size = 30;
    cursorArrow.scale = main.scaling;
    cursorArrow.color = 0xffd42a;

    setCursor();
    add(cursor);
    super(x, y, cursorArrow);
  }
}
