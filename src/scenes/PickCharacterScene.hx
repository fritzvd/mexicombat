package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Image;
import com.haxepunk.Entity;



class PickCharacterScene extends Scene
{

    public function new(){
        super();
    }

    public override function begin()
    {
        var bitmap:Image = new Image("graphics/pickcharacterbg.png");
        bitmap.x = - bitmap.width / 2;
        bitmap.y = - bitmap.height / 2;
        var titleEntity:Entity = new Entity(0,0,bitmap);
        titleEntity.x =  (bitmap.width/2);
        titleEntity.y =  (bitmap.height/2);
        add(titleEntity);
    }

    private function previousScene()
    {
        HXP.scene = new scenes.TitleScreen();
    }

    private function nextScene()
    {
        HXP.scene = new scenes.GameScene("gbjam", "gbjam");
    }

    #if android
    private function handleTouch(touch:com.haxepunk.utils.Touch) 
    {
        
        if (touch.pressed){
            nextScene();
        }
    }
    #end

    public override function update()
    {
        if (Input.check(Key.ESCAPE)) {
            previousScene();
        }
        if (Input.pressed(Key.X)) {
            nextScene();
        }
        #if android
        Input.touchPoints(handleTouch);
        #end
        super.update();
    }
}