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

import openfl.utils.JNI;

class PickCharacterScene extends Scene
{

    private var playerOne:String;
    private var playerTwo:String;
    private var selectOne:Entity;
    private var selectOneRect:Image;
    private var selectTwo:Entity;
    private var selectTwoRect:Image;
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
        // var font = Assets.getFont('font/feast.ttf');
        // pickCharacterText.font = font.fontName;
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
        addCharacter('fritz', 300, 200);
        selectOneRect = Image.createRect(charArray[playerOneSelected].width + 20 , charArray[playerOneSelected].height + 20, 0xB22222);
        selectOne = new Entity(charArray[playerOneSelected].x - 10, charArray[playerOneSelected].y - 10, selectOneRect);
        add(selectOne);
        selectTwoRect = Image.createRect(charArray[playerTwoSelected].width + 50 , charArray[playerTwoSelected].height + 20, 0x191970);
        selectTwo = new Entity(charArray[playerTwoSelected].x - 10, charArray[playerTwoSelected].y - 10, selectTwoRect);
        add(selectTwo);
        
        #if android
        var main = cast(HXP.engine, Main);
        if (main.plays > 1){
            trace('what is up');
            var showChartboost = JNI.createMemberMethod("com/cheeses/mexicombat/MainActivity", "showChartboost", "()V");
            showChartboost();
            trace('what is up with JNI');
        }
        #end

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
        playerTwo = charArray[playerTwoSelected].name;
        HXP.scene = new scenes.GameScene(playerOne, playerTwo);
    }

    #if mobile
    private function handleTouch(touch:com.haxepunk.utils.Touch) 
    {
        
        if (touch.pressed){
            nextScene();
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

    private function updateselectRect()
    {
        selectOne.x = charArray[playerOneSelected].x - 10;
        selectOne.y = charArray[playerOneSelected].y - 10;
        selectTwo.x = charArray[playerTwoSelected].x - 50;
        selectTwo.y = charArray[playerTwoSelected].y - 10;
    }

    private function selecting()
    {
        if (Input.pressed(Key.LEFT)) {
            if (playerOneSelected != 0) {
                playerOneSelected -= 1;
                updateselectRect();
            }
        }
        if (Input.pressed(Key.RIGHT)) {
            if (playerOneSelected != charArray.length) {
                playerOneSelected += 1;
                updateselectRect();
            }
        }
        if (Input.pressed(Key.A)) {
            if (playerTwoSelected != 0) {
                playerTwoSelected -= 1;
                updateselectRect();
            }
        }
        if (Input.pressed(Key.D)) {
            if (playerTwoSelected != charArray.length) {
                playerTwoSelected += 1;
                updateselectRect();
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
        #if mobile
        Input.touchPoints(handleTouch);
        #end
        super.update();
    }
}