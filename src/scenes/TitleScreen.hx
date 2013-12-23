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

        var bitmap:Image = new Image("graphics/splashscreen.png");
        bitmap.scale = main.scaling;
        bitmap.x = - bitmap.width / 2;
        bitmap.y = - bitmap.height / 2;
        var titleEntity:Entity = new Entity(0,0,bitmap);
        titleEntity.x =  (bitmap.width/2);
        titleEntity.y =  (bitmap.height/2);
        add(titleEntity);

        var kombatText:Text = new Text("KOMBAT ");
        // var font = Assets.getFont("font/feast.ttf");
        // kombatText.font = font.fontName;
        kombatText.size = 80;
        kombatText.scale = main.scaling;
        kombatText.color = 0xB22222;
        // var kombatImg:Image = new Image("graphics/kombat.png");
        // kombatText.angle = 20;
        var kombat:Entity = new Entity(360 * main.scaling,280 * main.scaling,kombatText);

        add(kombat);

        #if !mobile
        var titleText:Text = new Text("Press X to start");
        #end
        #if mobile
        var titleText:Text = new Text("Press anywhere to start");
        #end
        titleText.scale = main.scaling;
        titleText.color = 0x99aa59;
        var textEntity:Entity = new Entity(0, 50, titleText);
        textEntity.x = (HXP.width / 2) - (titleText.width/2);
        add(textEntity);

        #if android
        if (main.plays > 0){
            var showChartboost = JNI.createStaticMethod("com/cheeses/mexikombat/MainActivity", "showChartboost", "(I)V");         
            showChartboost(main.plays);
            // trace(main.plays);
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
        HXP.scene = new scenes.PickCharacterScene();
    }

    public override function update()
    {
        #if !mobile
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