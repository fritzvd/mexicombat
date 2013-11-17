package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.Entity;
import entities.Character;
import openfl.Assets;

class PickCharacterScene extends Scene
{

    private var playerOne:String;
    private var playerTwo:String;
    private var rectEntity:Entity;
    private var rectangle:Image;

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

        var pickCharacterText:Text = new Text("PICK a Character ");
        var font = Assets.getFont('font/feast.ttf');
        pickCharacterText.font = font.fontName;
        pickCharacterText.size = 80;
        pickCharacterText.color = 0xB22222;
        // var kombatImg:Image = new Image("graphics/kombat.png");
        // kombatText.angle = 20;
        var kombat:Entity = new Entity(100,50,pickCharacterText);

        add(kombat);

        playerOne = "gbjam";
        playerTwo = "gbjam";

        var playerOneSelected:Int = 0;
        var playerTwoSelected:Int = 1;

        // loop over characters
        // If character selected proceed to next window with character
        // characters for both players
        var charArray:Array<Entity> = [daniel, fritz];

            rectangle = Image.createRect(daniel.width + 20 , daniel.height + 20, 0xB22222);
            rectEntity = new Entity(daniel.x - 10, daniel.y - 10, rectangle);
            add(rectEntity);
    }

    private function previousScene()
    {
        HXP.scene = new scenes.TitleScreen();
    }

    private function addCharacter(charName:String, charX:Float, charY:Float)
    {
        var newChar:Character = new Character(charX, charY);
        newChar.set(charName);
        charArray.push(newChar);
    }

    private function nextScene()
    {
        HXP.scene = new scenes.GameScene(playerOne, playerTwo);
    }

    #if android
    private function handleTouch(touch:com.haxepunk.utils.Touch) 
    {
        
        if (touch.pressed){
            nextScene();
        }
    }
    #end

    private function rectangleColors()
    {
        while (rectangle.alpha < 1){
            rectangle.alpha += 0.1;
        } 

    }

    public override function update()
    {
        if (Input.pressed(Key.ESCAPE)) {
            previousScene();
        }
        if (Input.pressed(Key.X)) {
            nextScene();
        }    
        rectangleColors();
        #if android
        Input.touchPoints(handleTouch);
        #end
        super.update();
    }
}