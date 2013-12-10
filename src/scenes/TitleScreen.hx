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

class TitleScreen extends Scene
{

    public function new()
    {
        super();
    }

    public override function begin()
    {


        var bitmap:Image = new Image("graphics/splashscreen.png");
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
        kombatText.color = 0xB22222;
        // var kombatImg:Image = new Image("graphics/kombat.png");
        // kombatText.angle = 20;
        var kombat:Entity = new Entity(360,280,kombatText);

        add(kombat);

        #if !mobile
        var titleText:Text = new Text("Press X to start");
        #end
        #if mobile
        var titleText:Text = new Text("Press anywhere to start");
        #end
        titleText.color = 0x99aa59;
        var textEntity:Entity = new Entity(0, 50, titleText);
        textEntity.x = (HXP.width / 2) - (titleText.width/2);
        add(textEntity);

        // Actuate.tween (container, 3, { alpha: 1 } );
        // Actuate.tween (container, 4, { scaleX: 1, scaleY: 1 } ).delay (0.4).ease (Elastic.easeOut);
        
    }

    #if android
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
        #if !android
        if (Input.pressed(Key.X)) {
            // Input.stopProp
            startNext();
        }
        if (Input.check(Key.ESCAPE)) {
            HXP.scene.end();
        }
        #end
        #if android
        Input.touchPoints(handleTouch);
        #end
        super.update();
    }
}