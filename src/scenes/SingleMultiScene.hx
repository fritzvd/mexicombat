package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Text;
import com.haxepunk.Entity;
import entities.Character;
import openfl.Assets;


class SingleMultiScene extends Scene
{

    private var sNextButton:Entity;
    private var singlePlayer:Bool;
    private var cheese:Entity;
    private var scaling:Float;

    public function new(){
        super();
    }

    public override function begin()
    {
        singlePlayer = false;
        var main = cast(HXP.engine, Main);
        scaling = main.scaling;
        var bg:Image = new Image("graphics/singlebg.png");
        bg.scaleX = HXP.windowWidth / bg.width;
        bg.scaleY = HXP.windowHeight / bg.height;
        addGraphic(bg);

        var singleText:Text = new Text("Single Cheese");
        var font = Assets.getFont('font/feast.ttf');
        singleText.font = font.fontName;
        singleText.size = 70;
        singleText.color = 0x00000;
        singleText.scale = main.scaling;
        addGraphic(singleText, 40 * scaling, 10 * scaling);


        var multiText:Text = new Text("Two Cheeses");
        multiText.font = font.fontName;
        multiText.size = 70;
        multiText.color = 0x00000;
        multiText.scale = main.scaling;
        addGraphic(multiText, 40 * scaling, HXP.windowHeight / 2 + 10 * scaling);

        var nextText:Text = new Text("Next");
        var font = Assets.getFont('font/feast.ttf');
        nextText.font = font.fontName;
        nextText.size = 40;
        sNextButton = new Entity(HXP.windowWidth - 200 * main.scaling, 450 * main.scaling, nextText);
        sNextButton.width = nextText.width+5;
        sNextButton.height = nextText.height;
        sNextButton.name = "next";
        add(sNextButton);

        var cheeseImg:Image = new Image('graphics/cheese.png');
        cheese = new Entity(300 * scaling, 40 * scaling, cheeseImg);
        cheeseImg.scale = 4.5 * scaling;
        add(cheese);
        
    }

    private function previousScene()
    {
        HXP.scene = new scenes.TitleScreen();
    }

    private function nextScene()
    {
        HXP.scene = new scenes.PickCharacterScene(singlePlayer);
    }

    #if mobile
    private function handleTouch(touch:com.haxepunk.utils.Touch) 
    {
        if (touch.sceneY > HXP.height / 2) {
            singlePlayer = false;
        } else {
            singlePlayer = true;
        }
        var next:Bool = sNextButton.collideRect(
            touch.x, touch.y, sNextButton.x, sNextButton.y,
            sNextButton.width, sNextButton.height);
        if (next && touch.pressed) {
            // touch.stopPropagation();
            nextScene(singlePlayer);
        }
        
    }
    #end

    // private function selectOneRectColors()
    // {
    //     while (selectOneRect.alpha < 1) {
    //         selectOneRect.alpha += 0.01;
    //         trace(selectOneRect.alpha);
    //     } 
    //     if (selectOneRect.alpha == 1) {
    //         selectOneRect.alpha = 0;
    //     }

    // }


    public override function update()
    {
        if (Input.pressed(Key.ESCAPE)) {
            previousScene();
        }
        if (Input.pressed(Key.X)) {
            nextScene();
        }
        if (Input.pressed(Key.UP) || Input.pressed(Key.DOWN)) {
            singlePlayer = !singlePlayer;
        }
        if (singlePlayer) {
            cheese.y = 40 * scaling;
        } else {
            cheese.y = HXP.windowHeight / 2 + 40 * scaling;
        }
        #if mobile
        Input.touchPoints(handleTouch);
        #end
        super.update();
    }
}