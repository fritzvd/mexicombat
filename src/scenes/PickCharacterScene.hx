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


class PickCharacterScene extends Scene
{

    private var playerOne:String;
    private var playerTwo:String;
    private var selectOne:Entity;
    private var selectOneText:Text;
    private var selectTwo:Entity;
    private var selectTwoText:Text;
    private var sPlayerButton:Entity;
    private var sNextButton:Entity;
    private var charArray:Array<Entity>;
    private var singlePlayer:Bool;
    private var spImg:Spritemap;

    private var playerOneSelected:Int;
    private var playerTwoSelected:Int;

    public function new(){
        super();
    }

    public override function begin()
    {
        singlePlayer = false;
        var main = cast(HXP.engine, Main);
        var bitmap:Image = new Image("graphics/pickcharacterbg.png");
        bitmap.scale = main.scaling;
        bitmap.x = - bitmap.width / 2;
        bitmap.y = - bitmap.height / 2;
        var titleEntity:Entity = new Entity(0,0,bitmap);
        titleEntity.x =  (bitmap.width/2);
        titleEntity.y =  (bitmap.height/2);
        add(titleEntity);

        var pickCharacterText:Text = new Text("PICK a Character ");
        // var font = Assets.getFont('font/feast.ttf');
        // pickCharacterText.font = font.fontName;
        pickCharacterText.size = 70;
        pickCharacterText.color = 0xB22222;
        pickCharacterText.scale = main.scaling;
        // var kombatImg:Image = new Image("graphics/kombat.png");
        // kombatText.angle = 20;
        var kombat:Entity = new Entity(100,50,pickCharacterText);
        add(kombat);

        // var singlePlayerText:Text = new Text("Single Player");
        // var font = Assets.getFont('font/feast.ttf');
        // singlePlayerText.font = font.fontName;
        // singlePlayerText.size = 40;
        // singlePlayerText.color = 0xB22222;
        // singlePlayerText.scale = main.scaling;
        spImg = new Spritemap("graphics/singleplayer.png", 150, 50);
        spImg.add("single", [1], 1);
        spImg.add("multi", [0], 1);
        spImg.play("multi");
        // kombatText.angle = 20;
        sPlayerButton = new Entity(HXP.windowWidth - 200 * main.scaling, 150, spImg);
        sPlayerButton.width = spImg.width;
        sPlayerButton.height = spImg.height;
        sPlayerButton.name = "singlePlayer";
        add(sPlayerButton);


        var nextText:Text = new Text("Next");
        var font = Assets.getFont('font/feast.ttf');
        nextText.font = font.fontName;
        nextText.size = 40;
        sNextButton = new Entity(HXP.windowWidth - 200 * main.scaling, 450 * main.scaling, nextText);
        sNextButton.width = nextText.width+5;
        sNextButton.height = nextText.height;
        sNextButton.name = "next";
        add(sNextButton);

        playerOne = "";
        playerTwo = "";

        playerOneSelected = 0;
        playerTwoSelected = 1;

        charArray = [];

        // loop over characters
        // If character selected proceed to next window with character
        // characters for both players
        addCharacter('fritz', 100, 200);
        addCharacter('daniel', 300, 200);
        addCharacter('fritz', 100, 400);
        addCharacter('daniel', 300, 400);
        selectOneText = new Text("1");
        selectOneText.size = 20;
        selectOne = new Entity(charArray[playerOneSelected].x, charArray[playerOneSelected].y, selectOneText);
        add(selectOne);
        selectTwoText = new Text("2");
        selectTwoText.size = 20;
        selectTwo = new Entity(charArray[playerTwoSelected].x + charArray[playerTwoSelected].width - 15, 
            charArray[playerTwoSelected].y, selectTwoText);
        add(selectTwo);
        
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
        HXP.scene = new scenes.GameScene(playerOne, playerTwo, singlePlayer);
    }

    #if mobile
    private function handleTouch(touch:com.haxepunk.utils.Touch) 
    {
        var buttonCheck:Bool = sPlayerButton.collideRect(
            touch.x, touch.y, sPlayerButton.x, sPlayerButton.y,
            sPlayerButton.width, sPlayerButton.height);
        trace(touch.time, touch);
        if (buttonCheck) {
            if (singlePlayer) {
                spImg.play("multi");
                singlePlayer = false;    
            } else if (!singlePlayer) {
                spImg.play("single");
                singlePlayer = true;   
            }    
        }
        var next:Bool = sNextButton.collideRect(
            touch.x, touch.y, sNextButton.x, sNextButton.y,
            sNextButton.width, sNextButton.height);
        if (next) {
            nextScene();
        }
        
        // if (touch.pressed){
        //     nextScene();
        // }
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
        selectOne.x = charArray[playerOneSelected].x;
        selectOne.y = charArray[playerOneSelected].y;
        selectTwo.x = charArray[playerTwoSelected].x + charArray[playerTwoSelected].width - 15;
        selectTwo.y = charArray[playerTwoSelected].y;
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