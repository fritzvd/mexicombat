package scenes;

// import openfl.Assets;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

import entities.AIPlayer;
import entities.EmitController;
import entities.HealthBox;
import entities.Player;

class GameScene extends Scene
{

    private var playerone:Player;
    private var playertwo:Player;
    private var healthOne:HealthBox;
    private var healthTwo:HealthBox;
    private var chosenFighterOne:String;
    private var chosenFighterTwo:String;
    private var singlePlayer:Bool;

    public var roundTime:Float;
    private var roundText:Text;
    private var roundTextEntity:Entity;
    private var deadText:Text;
    private var deadTextEntity:Entity;
    private var deadTime:Float;
    private var scaling:Float;
    private var ec:EmitController;

    public function new(cFO:String, cFT:String, sP:Bool)
    {
        super();

        chosenFighterOne = cFO;
        chosenFighterTwo = cFT;
        roundTime = 45;
        deadTime = 0;
        singlePlayer = sP;

    }

    public override function begin()
    {

        ec = add(new EmitController());

        var main = cast(HXP.engine, Main);
        scaling = main.scaling;
        deadText = new Text("");
        // var font = Assets.getFont('font/feast.ttf');
        // deadText.font = font.fontName;
        deadText.size = 30;
        deadText.color = 0xFFFFFF;
        deadText.scale = main.scaling;
        // var kombatImg:Image = new Image("graphics/kombat.png");
        // kombatText.angle = 20;
        deadTextEntity = new Entity(250,250,deadText);
        deadTextEntity.visible = false;
        add(deadTextEntity);

        var bitmap:Image = new Image("graphics/bg.png");
        bitmap.x = - bitmap.width / 2;
        bitmap.y = - bitmap.height / 2;
        bitmap.scale = main.scaling * 0.677 ;
        var titleEntity:Entity = new Entity(0,0,bitmap);
        titleEntity.x =  (bitmap.width/2);
        titleEntity.y =  (bitmap.height/2);
        add(titleEntity);

        // TODO: players have namess
        // TODO: 
        playerone = new Player(200, 250);
        playerone.setKeysPlayer(Key.A, Key.D, Key.X, Key.Z, 0);
        healthOne = new HealthBox(100, 50);
        playerone.setHealthBox(healthOne);
        if (singlePlayer == true) {
            
            playertwo = new AIPlayer(400, 250);
        } else {
            // trace(singlePlayer);
            playertwo = new Player(400, 250);
            playertwo.setKeysPlayer(Key.LEFT, Key.RIGHT, Key.SHIFT, Key.ENTER, 1);
        }
        healthTwo = new HealthBox(300, 50);
        playertwo.setHealthBox(healthTwo);

        playerone.setPlayer(chosenFighterOne);
        playertwo.setPlayer(chosenFighterTwo);

        add(healthTwo);
        add(healthOne);
        add(playerone);
        add(playertwo);

        #if mobile
        var arrowYOffset = HXP.windowHeight / 2 + 200 * scaling;
        var arrowLeft:Image = new Image('graphics/ui-arrow.png');
        var arrowRight:Image = new Image('graphics/ui-arrow.png');
        arrowRight.flipped = true;

        addGraphic(arrowRight, HXP.windowWidth / 2 - 200 * scaling, arrowYOffset);
        addGraphic(arrowLeft, 100* scaling, arrowYOffset);
        addGraphic(arrowRight, HXP.windowWidth - 200 * scaling, arrowYOffset);
        addGraphic(arrowLeft, HXP.windowWidth / 2 + 100* scaling, arrowYOffset);
        #end

        roundText = new Text(Std.string(Math.round(roundTime)));
        // var font = Assets.getFont('font/feast.ttf');
        // pickCharacterText.font = font.fontName;
        roundText.size = 30;
        roundText.color = 0xB22222;
        // var kombatImg:Image = new Image("graphics/kombat.png");
        // kombatText.angle = 20;
        roundTextEntity = new Entity(250,50,roundText);
        add(roundTextEntity);

        playerone.setEnemy(playertwo, 0);
        playertwo.setEnemy(playerone, 1);

    }

    private function updateRoundTime()
    {
        if (roundTime > 0 && playertwo.fightingState != "dead" && playerone.fightingState != "dead")
        {
            roundTime -= HXP.elapsed;
        }
        roundText.text = Std.string(Math.round(roundTime));
        if (roundTime < 0)
        {
            if (playerone.health > playertwo.health) {
                playertwo.fightingState = "dead";
            } else {
                playerone.fightingState = "dead";
            }
        }
    }

    private function changeCamera()
    {   
        var random:Float = Math.random();
        if (random > 0.6) {
            HXP.camera.x = HXP.camera.x - Std.int(random * 10);
            HXP.camera.y = HXP.camera.y - Std.int(random * 10);            
        } else {
            HXP.camera.x = HXP.camera.x + Std.int(random * 10);
            HXP.camera.y = HXP.camera.y + Std.int(random * 10);            
        }
    }

    public override function update()
    {

        // if ((HXP.camera.x > 0) && (HXP.camera.x != 0)) {
        //     HXP.camera.x -= 1;

        // } else if ((HXP.camera.x < 0) && (HXP.camera.x != 0))  {
        //     HXP.camera.x += 1;
        // }
        // if ((HXP.camera.y > 0) && (HXP.camera.y != 0)) {
        //     HXP.camera.y -= 1;
        // } else if ((HXP.camera.y < 0) && (HXP.camera.y != 0))  {
        //     HXP.camera.y += 1;
        // }

        super.update();

        if (playerone.impact) {
            ec.impact(playerone.x + 150 * scaling, playerone.y + 60 * scaling);
            // changeCamera();
        } 
        if (playertwo.impact) {
            // changeCamera();
            ec.impact(playertwo.x + 150 * scaling, playertwo.y + 60 * scaling);
        }

        if (playerone.fightingState == "dead"){
            deadText.text = "Player one, you died.";
            deadTextEntity.visible = true;
            deadTime += HXP.elapsed;
        } 
        if (playertwo.fightingState == "dead"){
            deadText.text = "Player two, you died.";
            deadTextEntity.visible = true;
            deadTime += HXP.elapsed;
        }

        if (deadTime > 3) {
            HXP.scene = new scenes.TitleScreen();
        }


        if (Input.pressed(Key.ESCAPE)) {
            HXP.screen.color = 0x222233;
            HXP.scene = new scenes.TitleScreen();
        }
        updateRoundTime();
    }
}