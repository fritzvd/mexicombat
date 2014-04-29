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

import vault.Sfxr;
import vault.SfxrParams;

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

    private var sfx:Map<String, Sfxr>;

    public function new(cFO:String, cFT:String, sP:Bool)
    {
        super();

        chosenFighterOne = cFO;
        chosenFighterTwo = cFT;
        roundTime = 45;
        deadTime = 0;
        singlePlayer = sP;

        var params = new SfxrParams();
        params.generateExplosion();
        var hparams = new SfxrParams();
        hparams.generateHitHurt();

        sfx = new Map();
        sfx.set("explosion", new Sfxr(params));
        sfx.set("hithurt", new Sfxr(hparams));
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

        var bgBitmap:Image = new Image("graphics/bg_jochem.jpg");
        // bgBitmap.scale = HXP.windowWidth / bgBitmap.width;
        bgBitmap.scale = HXP.windowHeight / bgBitmap.height;
        addGraphic(bgBitmap, -370*scaling, 0);

        // TODO: players have namess
        // TODO: 
        playerone = new Player(200 * scaling, Math.floor(200 * scaling));
        playerone.setKeysPlayer(Key.A, Key.D, Key.X, Key.Z, 0);
        healthOne = new HealthBox(100, 50);
        playerone.setHealthBox(healthOne);

        #if mobile
        var arrowYOffset = HXP.windowHeight / 2 + 200 * scaling;
        var arrowLeft:Image = new Image('graphics/ui-arrow.png');
        var arrowRight:Image = new Image('graphics/ui-arrow.png');
        arrowRight.flipped = true;
        arrowRight.alpha = 0.6;
        arrowLeft.alpha = 0.6;

        addGraphic(arrowRight, -4, HXP.windowWidth / 2 - 200 * scaling, arrowYOffset);
        addGraphic(arrowLeft, -4, 100* scaling, arrowYOffset);
        #end
        if (singlePlayer) {
            playertwo = new AIPlayer(400, Math.floor(200 * scaling));
            #if mobile
            playerone.singlePlayer = true;
            #end
        } else {
            playertwo = new Player(400 * scaling, Math.floor(200 * scaling));
            playertwo.setKeysPlayer(Key.LEFT, Key.RIGHT, Key.SHIFT, Key.ENTER, 1);
            #if mobile
            addGraphic(arrowRight, -4, HXP.windowWidth - 200 * scaling, arrowYOffset);
            addGraphic(arrowLeft, -4, HXP.windowWidth / 2 + 100* scaling, arrowYOffset);
            #end
        }
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
        roundText.color = 0xf9cd22;
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

    private function soundFx()
    {
        if (playerone.impact || playertwo.impact) {

            sfx.get("hithurt").play();
        }
    }


    public override function update()
    {


        super.update();

        soundFx();
        if (playerone.impact) {
            ec.impact(playerone.x + 150 * scaling, playerone.y + 60 * scaling);
        } 
        if (playertwo.impact) {
            ec.impact(playertwo.x + 150 * scaling, playertwo.y + 60 * scaling);
        }

        if (playerone.fightingState == "dead"){
            deadText.text = "Player one, you died.";
            deadTextEntity.visible = true;
            deadTime += HXP.elapsed;
            sfx.get("explosion").play();

        } 
        if (playertwo.fightingState == "dead"){
            deadText.text = "Player two, you died.";
            deadTextEntity.visible = true;
            sfx.get("explosion").play();
            deadTime += HXP.elapsed;
        }

        if (deadTime > 3) {
            HXP.scene = new scenes.TitleScreen();
        }

        // quasi physics
        if (playerone.y < 200 * scaling) {
            playerone.y += 10;
        }
        if (playertwo.y < 200 * scaling) {
            playertwo.y += 10;
        }

        if (Input.pressed(Key.ESCAPE)) {
            HXP.screen.color = 0x222233;
            HXP.scene = new scenes.TitleScreen();
        }
        updateRoundTime();
    }
}