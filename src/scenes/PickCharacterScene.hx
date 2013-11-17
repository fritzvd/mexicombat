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
    private var charArray:Array<Entity>;

    private var playerOneSelected:Int;
    private var playerTwoSelected:Int;

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

        playerOneSelected = 0;
        playerTwoSelected = 1;

        charArray = [];

        // loop over characters
        // If character selected proceed to next window with character
        // characters for both players
        addCharacter('fritz', 100, 200);
        addCharacter('daniel', 300, 200);

        
            rectangle = Image.createRect(charArray[playerOneSelected].width + 20 , charArray[playerOneSelected].height + 20, 0xB22222);
            rectEntity = new Entity(charArray[playerOneSelected].x - 10, charArray[playerOneSelected].y - 10, rectangle);
            add(rectEntity);
    }

    private function previousScene()
    {
        HXP.scene = new scenes.TitleScreen();
    }

    private function addCharacter(charName:String, charX:Float, charY:Float)
    {

        var newChar:Character = new Character(charX, charY);
        add(newChar);
        newChar.set(charName);
        charArray.push(newChar);
    }

    private function nextScene()
    {
        playerOne = charArray[playerOneSelected].name;
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
        while (rectangle.alpha < 1) {
            rectangle.alpha += 0.01;
            trace(rectangle.alpha);
        } 
        if (rectangle.alpha == 1) {
            rectangle.alpha = 0;
        }

    }

    private function updateRectangle()
    {
        rectEntity.x = charArray[playerOneSelected].x - 10;
        rectEntity.y = charArray[playerOneSelected].y - 10;
    }

    private function selecting()
    {
        if (Input.pressed(Key.LEFT)) {
            if (playerOneSelected != 0) {
                playerOneSelected -= 1;
                updateRectangle();
            }
        }
        if (Input.pressed(Key.RIGHT)) {
            if (playerOneSelected != charArray.length) {
                playerOneSelected += 1;
                updateRectangle();
            }
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
        selecting();
        #if android
        Input.touchPoints(handleTouch);
        #end
        super.update();
    }
}