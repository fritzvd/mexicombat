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

    public function new()
    {
        super();
    }

    public override function begin()
    {
        var main = cast(HXP.engine, Main);
        
        var running:Spritemap = new Spritemap("graphics/bg_running_lores3.png", 80, 41);
        running.add("default", [0,1,2,3,4,5,6,7,8,9,
            10,11,12,13,14,15,16,17,18,19], 15);
        running.play("default");
        running.scaleX = HXP.windowWidth / running.width;
        running.scaleY = HXP.windowHeight / running.height;
        addGraphic(running);

        var bitmap:Image = new Image("graphics/splashscreen_lores.png");
        bitmap.scaleX = HXP.windowWidth / bitmap.width;
        bitmap.scaleY = HXP.windowHeight / bitmap.height;
        addGraphic(bitmap);

        var kombatText:Text = new Text("KOMBAT ", {color: 0xC50000});
        kombatText.size = 80;
        kombatText.scale = main.scaling;
        addGraphic(kombatText, 600 * main.scaling, 360 * main.scaling);

        #if !mobile
        var titleText:Text = new Text("Press X to start");
        #end
        #if mobile
        var titleText:Text = new Text("Press anywhere to start");
        #end
        titleText.scale = main.scaling;
        // titleText.color = 0xB22222;
        titleText.color = 0x99aa59;

        #if mobile
        var scaling = main.scaling;
        var arrowYOffset = HXP.windowHeight / 2 + 200 * scaling;
        var arrowRight:Image = new Image('graphics/ui-arrow.png');
        arrowRight.flipped = true;
        addGraphic(arrowRight, HXP.windowWidth - 200 * scaling, arrowYOffset);
        #end

        var textEntity:Entity = new Entity(0, 50, titleText);
        textEntity.x = (HXP.width / 2) - (titleText.width/2);
        add(textEntity);
            #if android
            // var main = cast(HXP.engine, Main);
            if ((main.plays > 0) && (main.plays % 3 == 0)){
                var showLink = JNI.createStaticMethod("com/cheeses/mexikombat/MainActivity", "showLink", "()V");         
                showLink();
            }
            #end   
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
        HXP.scene = new scenes.SingleMultiScene();
    }

    public override function update()
    {
        #if !mobile
        if (Input.joysticks > 0 ) {
           if (Input.joystick(0).pressed()) {
                startNext();
           }
        }
        if (Input.pressed(Key.X)) {
            // Input.stopProp
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
