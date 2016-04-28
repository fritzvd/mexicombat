package scenes;

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
    private var cursorArrow:Text;
    private var cursor:Entity;
    private var fade:Bool;
    private var menuItems:Map<String,Entity>;
    private var main = cast(HXP.engine, Main);
    private var state:Map<String, Bool>;
    public function new()
    {
        super();

        state = ['start'=> true, 'select'=> false];
        menuItems = new Map();
    }

    public override function begin()
    {

        var splash:Image = new Image("graphics/menu/mexikombat.png");
        splash.scale = 1.3 * main.scaling;
        splash.smooth = false;
        var splashEntity = addGraphic(splash);
        splashEntity.x = HXP.windowWidth / 2 - 310 * main.scaling;
        splashEntity.y = HXP.windowHeight / 2 - 270 * main.scaling;

        addMenuItem('startgame');

        cursorArrow = new Text(">");
		    cursorArrow.size = 30;
        cursorArrow.scale = main.scaling;
        cursorArrow.color = 0xffd42a;

        cursor = new Entity(0, 570 * main.scaling, cursorArrow);
        cursor.x = (HXP.width / 2) - (cursorArrow.width / 2) - 180 * main.scaling;
        add(cursor);
        #if android
        if ((main.plays > 0) && (main.plays % 3 == 0)){
          var showLink = JNI.createStaticMethod("com/cheeses/mexikombat/MainActivity", "showLink", "()V");
          showLink();
        }
        #end
    }

    private function addMenuItem (menuTitle) {
      menuItems[menuTitle] = new Entity(
        0,
        570 * main.scaling,
        new Image('graphics/menu/' + menuTitle + '.png')
      );

    }

    #if mobile
    private function handleTouch(touch:com.haxepunk.utils.Touch)
    {

        if (touch.pressed){
            startNext();
        }
    }
    #end

    private function startNext()
    {
        HXP.scene = new scenes.PickCharacterScene(false);
    }

    private function goBack() {

    }

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
        if (Input.joysticks > 0 ) {
           if (Input.joystick(0).pressed()) {
                startNext();
           }
        }

        if (Input.pressed(Key.X)) {
            startNext();
        }
        if (Input.check(Key.ESCAPE)) {
            HXP.scene.end();
        }
        #end

        #if mobile
        Input.touchPoints(handleTouch);
        #end
        super.update();
    }
}
