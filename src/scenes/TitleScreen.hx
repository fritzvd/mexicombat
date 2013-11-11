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

        var kombatImg:Image = new Image("graphics/kombat.png");
        kombatImg.angle = 10;
        var kombat:Entity = new Entity(350,300,kombatImg);

        add(kombat);

        #if !android
        var titleText:Text = new Text("Press X to start");
        #end
        #if android
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
        if (Input.check(Key.X)) {
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