package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Joystick;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Text;
import com.haxepunk.Entity;
import openfl.Assets;

import entities.Character;
import entities.Player;
import entities.HealthBox;

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
    private var char1Array:Array<Entity>;
    private var char2Array:Array<Entity>;
    private var singlePlayer:Bool;
    private var spImg:Spritemap;

    private var playerOneSelected:Int;
    private var playerTwoSelected:Int;

    private var firstCheese:Entity;
    private var secondCheese:Entity;
    private var touchEntity:Entity;

    private var selectedCharacter1:Player;
    private var selectedCharacter2:Player;
    private var main:Main;

    public function new(sP:Bool){
        super();
        singlePlayer = sP;
    }

    public override function begin()
    {
        main = cast(HXP.engine, Main);

        var bg:Image = new Image("graphics/singlebg.png");
        bg.scaleX = HXP.windowWidth / bg.width;
        bg.scaleY = HXP.windowHeight / bg.height;
        addGraphic(bg);

        var pickCharacterText:Text = new Text("PICK a Character ", {color: 0xC50000});
        // var font = Assets.getFont('font/feast.ttf');
        // pickCharacterText.font = font.fontName;
        pickCharacterText.size = 70;
        pickCharacterText.color = 0xB22222;
        pickCharacterText.scale = main.scaling;
        // var kombatImg:Image = new Image("graphics/kombat.png");
        // kombatText.angle = 20;
        var kombat:Entity = new Entity(100,50,pickCharacterText);
        add(kombat);

        var nextText:Text = new Text("Next");
        var font = Assets.getFont('font/feast.ttf');
        nextText.font = font.fontName;  
        nextText.size = Std.int(100 * main.scaling);
        sNextButton = new Entity(HXP.windowWidth - 200 * main.scaling, 450 * main.scaling, nextText);
        sNextButton.width = nextText.width+5;
        sNextButton.height = nextText.height;
        sNextButton.name = "next";
        add(sNextButton);

        playerOne = "";
        playerTwo = "";

        playerOneSelected = 0;
        playerTwoSelected = 1;

        char1Array = [];
        char2Array = [];

        var characters:Array<String> = [
                'fritz', 
                'jonathan',
                'jilles',
				'bob',
                'daniel'
                ];


        for (i in 0...characters.length) {
			var screenFifth = HXP.stage.stageHeight / 5;
            addCharacter(characters[i], HXP.stage.stageWidth - 100 * main.scaling,
                screenFifth * i, 2);
            addCharacter(characters[i], 100 * main.scaling,
                screenFifth * i, 1);
        }

        selectOneText = new Text("1");
        selectOneText.size = 20;
        selectOne = new Entity(char1Array[playerOneSelected].x, char1Array[playerOneSelected].y, selectOneText);
        add(selectOne);
        selectTwoText = new Text("2");
        selectTwoText.size = 20;
        selectTwo = new Entity(char2Array[playerTwoSelected].x + char2Array[playerTwoSelected].width - 15, 
            char2Array[playerTwoSelected].y, selectTwoText);
        add(selectTwo);

        selectedCharacter1 = new Player(200 * main.scaling, 120 * main.scaling);
        selectedCharacter1.setKeysPlayer(Key.P, Key.P, Key.P, Key.P, 2);
        selectedCharacter1.fightingState = "idle";
        selectedCharacter1.setPlayer('fritz');
        selectedCharacter1.sprite.scale = 1.5 * main.scaling;
        add(selectedCharacter1);
        selectedCharacter2 = new Player(500 * main.scaling, 120 * main.scaling);
        selectedCharacter2.setKeysPlayer(Key.P, Key.P, Key.P, Key.P, 2);
        selectedCharacter2.fightingState = "idle";
        selectedCharacter2.setPlayer('daniel');
        selectedCharacter2.sprite.scale = 1.5 * main.scaling;
        add(selectedCharacter2);

        // refactor this shit
        selectedCharacter1.setEnemy(selectedCharacter2, 1);
        selectedCharacter2.setEnemy(selectedCharacter1, 0);
        var healthTwo = new HealthBox(4000, 4000);
        selectedCharacter2.setHealthBox(healthTwo);
        selectedCharacter1.setHealthBox(healthTwo);
        // Y height etc. Should be going in the scene not in the player.hx


#if mobile
        touchEntity = new Entity();
        add(touchEntity);
#end        
    }

    private function previousScene()
    {
        HXP.scene = new scenes.TitleScreen();
    }

    private function addCharacter(charName:String, charX:Float, charY:Float, player:Int)
    {

        var newChar:Character = new Character(charX, charY);
        add(newChar);
        newChar.set(charName);
		if (player == 1) {
			char1Array.push(newChar);
		} else {
			char2Array.push(newChar);
		}
    }

    private function nextScene()
    {
        playerOne = char1Array[playerOneSelected].name;
        playerTwo = char2Array[playerTwoSelected].name;
        HXP.scene = new scenes.GameScene(playerOne, playerTwo, singlePlayer);
    }

    #if mobile
    private function handleTouch(touch:com.haxepunk.utils.Touch) 
    {
        // var touchEntity = new Entity(touch.x, touch.y);
        touchEntity.x = touch.x;
        touchEntity.y = touch.y;
        var touchedpiet:Entity = touchEntity.collide("character", touch.x, touch.y);
        if (touchedpiet != null) {
            var characterTouch:Character = cast(touchedpiet, Character);
            playerOneSelected = Lambda.indexOf(char1Array, characterTouch);
            updateselectRect();
        }

        var next:Bool = sNextButton.collideRect(
            touch.x, touch.y, sNextButton.x, sNextButton.y,
            sNextButton.width, sNextButton.height);
        if (next && touch.pressed) {
            nextScene();
        }        
    }
    #end

    private function updateselectRect()
    {
        selectOne.x = char1Array[playerOneSelected].x;
        selectOne.y = char1Array[playerOneSelected].y;
        selectTwo.x = char2Array[playerTwoSelected].x + char1Array[playerTwoSelected].width - 15;
        selectTwo.y = char2Array[playerTwoSelected].y;

        selectedCharacter1.setPlayer(char1Array[playerOneSelected].name);
        selectedCharacter1.sprite.scale = 1.5 * main.scaling;
        selectedCharacter2.setPlayer(char2Array[playerTwoSelected].name);
        selectedCharacter2.sprite.scale = 1.5 * main.scaling;

    }

    private function getJoystick(joyNr) {
        if (Input.joysticks == 0 ||
            Input.joystick(joyNr) == null) {
            return '';
        } else {
            var joystick:Joystick = Input.joystick(joyNr);
            if (joystick.check(XBOX_GAMEPAD.DPAD_LEFT)) {
                return 'LEFT';
            }
            if (joystick.check(XBOX_GAMEPAD.DPAD_RIGHT)) {
                return 'RIGHT';
            }
            return '';
        }
        return '';
    }

    private function selecting()
    {
        
        if (Input.pressed(Key.LEFT) ||
            getJoystick(0) == 'LEFT') {
            if (playerOneSelected != 0) {
                playerOneSelected -= 1;
                updateselectRect();
            }
        }
        if (Input.pressed(Key.RIGHT) ||
            getJoystick(0) == 'RIGHT') {
            if (playerOneSelected != char1Array.length - 1) {
                playerOneSelected += 1;
                updateselectRect();
            }
        }
        if (Input.pressed(Key.A) ||
            getJoystick(1) == 'LEFT') {
            if (playerTwoSelected != 0) {
                playerTwoSelected -= 1;
                updateselectRect();
            }
        }
        if (Input.pressed(Key.D) ||
            getJoystick(1) == 'LEFT') {
            if (playerTwoSelected != char2Array.length - 1) {
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
