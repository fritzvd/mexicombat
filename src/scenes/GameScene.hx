package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;
import entities.Player;
import entities.HealthBox;

import com.haxepunk.graphics.Image;
import openfl.Assets;
import com.haxepunk.graphics.Text;
import com.haxepunk.Entity;
#if android
import openfl.utils.JNI;
#end

class GameScene extends Scene
{

    private var playerone:Player;
    private var playertwo:Player;
    private var healthOne:HealthBox;
    private var healthTwo:HealthBox;
    private var chosenFighterOne:String;
    private var chosenFighterTwo:String;

    public var roundTime:Float;
    private var roundText:Text;
    private var roundTextEntity:Entity;
    private var deadText:Text;
    private var deadTextEntity:Entity;
    private var deadTime:Float;

    public function new(cFO:String, cFT:String)
    {
        super();

        chosenFighterOne = cFO;
        chosenFighterTwo = cFT;
        roundTime = 45;
        deadTime = 0;


    }

    public override function begin()
    {

        var main = cast(HXP.engine, Main);
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

        // TODO: players can be chosen
        // TODO: players have namess
        // TODO: 
        playerone = new Player(200, 250);
        playerone.setKeysPlayer(Key.A, Key.D, Key.X, Key.Z, 0);
        healthOne = new HealthBox(100, 50);
        playerone.setHealthBox(healthOne);
        playertwo = new Player(400, 250);
        playertwo.setKeysPlayer(Key.LEFT, Key.RIGHT, Key.SHIFT, Key.ENTER, 1);
        healthTwo = new HealthBox(300, 50);
        playertwo.setHealthBox(healthTwo);

        playerone.setPlayer(chosenFighterOne);
        playertwo.setPlayer(chosenFighterTwo);

        add(healthTwo);
        add(healthOne);
        add(playerone);
        add(playertwo);

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

    public override function update()
    {

        super.update();


        if (playerone.fightingState == "dead"){
            deadText.text = "Player one, you died.";
            // deadTextEntity = new Entity(250,250,deadText);
            deadTextEntity.visible = true;
            deadTime += HXP.elapsed;
           #if android
            var main = cast(HXP.engine, Main);
            if (main.plays > 0){
                var showChartboost = JNI.createStaticMethod("com/cheeses/mexikombat/MainActivity", "showChartboost", "(I)V");         
                showChartboost(main.plays);
                // trace(main.plays);
            }
            #end
        } 
        if (playertwo.fightingState == "dead"){
            deadText.text = "Player two, you died.";
            // deadTextEntity = new Entity(250,250,deadText);
            deadTextEntity.visible = true;
            deadTime += HXP.elapsed;
           #if android
            var main = cast(HXP.engine, Main);
            if (main.plays > 0){
                var showChartboost = JNI.createStaticMethod("com/cheeses/mexikombat/MainActivity", "showChartboost", "(I)V");         
                // trace(main.plays);
                showChartboost(main.plays);
            }
            #end
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