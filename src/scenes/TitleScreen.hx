package scenes;

import Inputs;

import com.haxepunk.Entity;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Touch;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Tween;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import openfl.Assets;

#if android
import openfl.utils.JNI;
#end

class TitleScreen extends Scene
{
    private var cursorArrow:Image;
    private var cursor:Entity;
    private var cursorItem:Int;
    private var fade:Bool;
    private var menuItems:Array<Entity>;
    private var main = cast(HXP.engine, Main);
    private var state:Map<String, Bool>;
    public function new()
    {
        super();

        state = ['start'=> true, 'select'=> false];
        menuItems = [];
        var splash:Image = new Image("graphics/menu/mexikombat.png");
        splash.scale = 1.3 * main.scaling;
        splash.smooth = false;
        var splashEntity = addGraphic(splash);
        splashEntity.name = 'splash';
        trace(splash.scaleX, splash.scaledWidth);
        splashEntity.x = HXP.windowWidth / 2 - splash.scaledWidth / 2 - 40 * main.scaling;
        splashEntity.y = HXP.windowHeight / 2 - 270 * main.scaling;
    }

    public override function begin()
    {
        // initial menu item.
        addMenuItem('startgame');
        cursorItem = 0;

        cursorArrow = new Image("graphics/menu/cursor.png");
        cursorArrow.scale = main.scaling;
        cursorArrow.color = 0xffd42a;

        cursor = new Entity(0, 570 * main.scaling, cursorArrow);
        setCursor();
        add(cursor);
    }

    private function addMenuItem (menuTitle) {
      var img = new Image('graphics/menu/' + menuTitle + '.png');
      img.scale = main.scaling;
      var menuItem = new Entity(
        0,
        570 * main.scaling,
        img
      );
      menuItem.setHitboxTo(img);
      menuItem.collidable = true;
      menuItems.push(menuItem);
      menuItem.name = menuTitle;
      add(menuItem);

      // i don't care anymore
      for (mi in menuItems) {
        var itemIdx = menuItems.indexOf(mi);
        mi.x = (HXP.windowWidth / menuItems.length) * itemIdx + 20 * main.scaling;
      }
      if (menuItems.length == 1) {
        menuItem.x = HXP.halfWidth - cast(menuItem.graphic, Image).scaledWidth / 2;
      }
    }

    private function setCursor () {
      var menuItem = menuItems[cursorItem];
      cursor.x = menuItem.x - 36 * main.scaling;
    }


    private function moveCursor(?left:Bool) {
      var direction = (left) ? -1 : 1;

      if (cursorItem == 0 && direction == -1) {
        cursorItem = menuItems.length - 1;
      } else if (cursorItem == menuItems.length - 1 && direction == 1) {
        cursorItem = 0;
      } else {
        cursorItem = cursorItem + direction;
      }

      setCursor();
    }

    private function startNext(clicked:Entity)
    {
      switch(clicked.name) {
        case 'startgame':
        nextMenu();
        case '1player':
        HXP.scene = new scenes.PickCharacterScene(true);
        case '2players':
        HXP.scene = new scenes.PickCharacterScene(false);
        case 'credits':
        HXP.scene = new scenes.Credits();
      }
    }

    private function nextMenu() {
      for (menuItem in menuItems) {
        this.remove(menuItem);
      }
      menuItems = [];
      addMenuItem('1player');
      addMenuItem('2players');
      addMenuItem('credits');
      cursorItem = 0;
      setCursor();
    }

    #if mobile
    private function handleTouch(touch:com.haxepunk.utils.Touch) {
      if (touch.pressed) {
        var clicked:Entity;
        var touch = new Entity(touch.x, touch.y);
        touch.setHitbox(20, 20, -10, -10);
        for (menuItem in menuItems) {
          clicked = touch.collideWith(menuItem, touch.x, touch.y);
          trace(clicked);
          if (clicked != null) {
            trace(clicked);
            startNext(clicked);
            break;
          }
        }
      }
    }
    #end

    #if !mobile
    private function handleInput () {
      if ((Inputs.direction() == Inputs.UP) ||
          (Inputs.direction() == Inputs.LEFT)) {
          moveCursor(true);
      }
      if ((Inputs.direction() == Inputs.DOWN) ||
          (Inputs.direction() == Inputs.RIGHT)) {
          moveCursor(false);
      }

      if (Inputs.action() == 'forward') {
        startNext(menuItems[cursorItem]);
      }

      if (Inputs.action() == 'back') {
        HXP.scene = new scenes.TitleScreen();
      }
    }
    #end

    public override function update()
    {

         if (cursorArrow.alpha >= 1.0) {
          fade = true;
        } else if (cursorArrow.alpha <= 0.0) {
          fade = false;
        }

        if (fade) {
          cursorArrow.alpha -= HXP.elapsed;
        } else {
          cursorArrow.alpha += HXP.elapsed;
        }

        #if !mobile
        handleInput();
        #end

        #if mobile
        Input.touchPoints(handleTouch);
        #end
        super.update();
    }
}
