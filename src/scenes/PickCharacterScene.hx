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
    private var selectOneImage:Image;
    private var selectTwo:Entity;
    private var selectTwoImage:Image;
    private var sPlayerButton:Entity;
    private var sNextButton:Entity;
    private var sBackButton:Entity;
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

    private var playerScale:Float = 1.4;

    public function new(sP:Bool){
        super();
        singlePlayer = sP;
    }

    public override function begin()
    {
        main = cast(HXP.engine, Main);

        var bg:Image = new Image("graphics/menu/background.png");
        bg.scaleX = HXP.width / bg.width;
        bg.scaleY = HXP.height / bg.height;
        addGraphic(bg);

        var pick:Image = new Image('graphics/menu/pick.png');
        pick.scale = main.scaling + 0.2;
        pick.smooth = false;
        addGraphic(pick, HXP.halfWidth - pick.scaledWidth / 2, 100 * main.scaling);

        var vs:Image = new Image('graphics/menu/vs.png');
        vs.scale = main.scaling + 0.2;
        vs.smooth = false;
        addGraphic(vs, HXP.halfWidth - vs.scaledWidth / 2, 400 * main.scaling);

        var backText:Image = new Image('graphics/menu/back.png');
        backText.smooth = false;
        backText.scale = playerScale * main.scaling;
        sBackButton = new Entity(
          HXP.halfWidth - (backText.scaledWidth + 70 * main.scaling),
          550 * main.scaling, backText
        );
        sBackButton.width = backText.width + 5;
        sBackButton.height = backText.height;
        sBackButton.name = "back";
        sBackButton.type = 'menu';
        add(sBackButton);

        var nextText:Image = new Image('graphics/menu/next.png');
        nextText.scale = playerScale * main.scaling;
        nextText.smooth = false;
        sNextButton = new Entity(HXP.halfWidth + 70 * main.scaling, 550 * main.scaling, nextText);
        sNextButton.width = Std.int(nextText.scaledWidth + 5);
        sNextButton.height = Std.int(nextText.scaledHeight);
        sNextButton.name = "next";
        sNextButton.type = 'menu';
        add(sNextButton);

        playerOne = "";
        playerTwo = "";

        playerOneSelected = Math.round(Math.random() * 4);
        playerTwoSelected = Math.round(Math.random() * 4);

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
          var screenFifth = HXP.height / 5;
          addCharacter(
            characters[i], HXP.width - 80 * main.scaling - HXP.screen.x,
            screenFifth * i + main.scaling * 10, 2
          );
          addCharacter(
            characters[i], 100 * main.scaling - HXP.screen.x,
            screenFifth * i + main.scaling * 10, 1
          );
        }

        var squareSize = Std.int(20 * main.scaling);
        selectOneImage = Image.createRect(squareSize, squareSize, 0x00FF00, 0.8);
        selectOne = new Entity(char1Array[playerOneSelected].x, char1Array[playerOneSelected].y, selectOneImage);
        add(selectOne);
        selectTwoImage = Image.createRect(squareSize, squareSize, 0xFF0000, 0.8);
        selectTwo = new Entity(char2Array[playerTwoSelected].x + char2Array[playerTwoSelected].width - 15,
        char2Array[playerTwoSelected].y, selectTwoImage);
        add(selectTwo);

        selectedCharacter1 = new Player(150 * main.scaling, 110 * main.scaling);
        selectedCharacter1.setKeysPlayer(Key.P, Key.P, Key.P, Key.P, 2);
        selectedCharacter1.fightingState = "idle";
        selectedCharacter1.setPlayer(characters[playerOneSelected]);
        selectedCharacter1.sprite.scale = playerScale * main.scaling;
        add(selectedCharacter1);
        selectedCharacter2 = new Player(500 * main.scaling, 110 * main.scaling);
        selectedCharacter2.setKeysPlayer(Key.P, Key.P, Key.P, Key.P, 2);
        selectedCharacter2.fightingState = "idle";
        selectedCharacter2.setPlayer(characters[playerTwoSelected]);
        selectedCharacter2.sprite.scale = playerScale * main.scaling;
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
          newChar.mugshot.flipped = true;
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
        touchEntity.x = touch.x;
        touchEntity.y = touch.y;
        var touchedChar:Entity = touchEntity.collide("character", touch.x, touch.y);
        if (touchedChar != null) {
            var characterTouch:Character = cast(touchedChar, Character);
            if (touch.x < HXP.halfWidth) {
                playerOneSelected = Lambda.indexOf(char1Array, characterTouch);
            } else if (touch.x > HXP.halfWidth) {
                playerTwoSelected = Lambda.indexOf(char2Array, characterTouch);
            }
            updateselectRect();
        }


        // var back:Bool = sBackButton.collideRect(
        //     touch.x, touch.y, sBackButton.x, sBackButton.y,
        //     sBackButton.width, sBackButton.height
        // );
        // var next:Bool = sNextButton.collideRect(
        //     touch.x, touch.y, sNextButton.x, sNextButton.y,
        //     sNextButton.width, sNextButton.height
        // );

        var menuTouch:Entity = touchEntity.collide('menu', touch.x, touch.y);
        if (menuTouch != null) {
          if (menuTouch.name == 'next') {
            nextScene();
          }
          if (menuTouch.name == 'back') {
            previousScene();
          }
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
        selectedCharacter1.sprite.scale = playerScale * main.scaling;
        selectedCharacter2.setPlayer(char2Array[playerTwoSelected].name);
        selectedCharacter2.sprite.scale = playerScale * main.scaling;

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
        if (Input.pressed(Key.X) || Input.pressed(Key.ENTER)) {
            nextScene();
        }
        selecting();
        #if mobile
        Input.touchPoints(handleTouch);
        #end
        super.update();
    }
}
