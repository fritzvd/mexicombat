package scenes;

import openfl.Assets;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Sfx;

import entities.AIPlayer;
import entities.EmitController;
import entities.HealthBox;
import entities.Player;
import entities.RoundText;

class GameScene extends Scene
{

    private var playerone:Player;
    private var playertwo:Player;
    private var healthOne:HealthBox;
    private var healthTwo:HealthBox;
    private var chosenFighterOne:String;
    private var chosenFighterTwo:String;
    private var singlePlayer:Bool;

    private var topOffset:Int = 30;
    private var roundText:RoundText;
    //private var roundTextEntity:Entity;
    // private var deadText:Text;
    // private var deadTextEntity:Entity;
    private var deadTime:Float;
    private var scaling:Float;
    private var ec:EmitController;
    private var maxWidth:Float;
    private var finished:Bool;
    private var halfWidth = HXP.width / 2 - HXP.screen.y;
    // private var font = Assets.getFont('font/Fixedsys500c.ttf');
    private var sfx:Map<String, Sfx>;

    public var roundTime:Float;

    public function new(cFO:String, cFT:String, sP:Bool) {
        super();

		    finished = false;
        chosenFighterOne = cFO;
        chosenFighterTwo = cFT;
        roundTime = 45;
        deadTime = 0;
        singlePlayer = sP;

        var main = cast(HXP.engine, Main);
        scaling = main.scaling;

        topOffset = Std.int(topOffset * scaling);

        sfx = new Map();
        sfx.set("dead", new Sfx("audio/dead.ogg"));
        sfx.set("impact0", new Sfx("audio/impact0.ogg"));
        sfx.set("impact1", new Sfx("audio/impact1.ogg"));
        sfx.set("impact2", new Sfx("audio/impact2.ogg"));
        sfx.set("punch0", new Sfx("audio/punch0.ogg"));
        sfx.set("punch1", new Sfx("audio/punch1.ogg"));
        sfx.set("punch2", new Sfx("audio/punch2.ogg"));
	  }

    public override function begin()
    {

        ec = add(new EmitController());

        var bgBitmap:Image = new Image("graphics/background.jpg");
        bgBitmap.smooth = false;
        bgBitmap.scale = 1.3 * scaling;
        addGraphic(bgBitmap, 0, 0);
        maxWidth = bgBitmap.scaledWidth - HXP.screen.x;

        camera.x = bgBitmap.scaledWidth / 2 - 300 * scaling;

        var hatdancer = new Spritemap("graphics/dancers/hat.jpg", 85, 133);
        hatdancer.smooth = false;
        hatdancer.scale = 1.3 * scaling;
        hatdancer.add("dance", [0,0,0,0,0,0,1,2,2,2,2,2,2], 3);
        hatdancer.play("dance");
        addGraphic(hatdancer, 362 * 1.3 * scaling, 86 * 1.3 * scaling);

        var chicken = new Spritemap("graphics/dancers/chicken.jpg", 125, 161);
        chicken.smooth = false;
        chicken.scale = 1.3 * scaling;
        chicken.add("dance", [0,0,0,0,0,0,0,0,0,1,2,3], 6);
        chicken.play("dance");
        addGraphic(chicken, 822 * 1.3 * scaling, 223 * 1.3 * scaling);

        var whiteshirt = new Spritemap("graphics/dancers/whiteshirt.jpg", 93, 135);
        whiteshirt.smooth = false;
        whiteshirt.scale = 1.3 * scaling;
        whiteshirt.add("dance", [0,1,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3], 4);
        whiteshirt.play("dance");
        addGraphic(whiteshirt, 252 * 1.3 * scaling, 112 * 1.3 * scaling);

        var jump = new Spritemap("graphics/dancers/jump.jpg", 123, 141);
        jump.smooth = false;
        jump.scale = 1.3 * scaling;
        jump.add("dance", [0,0,0,0,0,1,2,3, 3, 3, 3], 4);
        jump.play("dance");
        addGraphic(jump, 926 * 1.3 * scaling, 109 * 1.3 * scaling);

        playerone = new Player(Math.floor(250 * scaling), Math.floor(200 * scaling));
        playerone.setKeysPlayer(Key.A, Key.D, Key.X, Key.Z, 0);
        var healthOffset = 60 * scaling - HXP.screen.y;
        healthOne = new HealthBox(Std.int(healthOffset * scaling), topOffset);
        healthOne.flipped();
        playerone.setHealthBox(healthOne);
        var mugshot1 = new Image("graphics/"+ chosenFighterOne + "sm.png");
        mugshot1.scrollX = 0;
        mugshot1.scale = scaling;
        mugshot1.x = Std.int(healthOffset - 80 * scaling);
        mugshot1.y = topOffset;
        mugshot1.smooth = false;
        addGraphic(mugshot1);
        var fighterOneName = new Image("graphics/names/" + chosenFighterOne + ".png");
        fighterOneName.scrollX = 0;
        fighterOneName.scale = scaling;
        fighterOneName.x = (Std.int(healthOffset * scaling));
        fighterOneName.y = topOffset + Std.int(30 * scaling);
        fighterOneName.smooth = false;
        addGraphic(fighterOneName);

        #if mobile
        var arrowYOffset = HXP.height / 2 + 200 * scaling;
        var arrowLeft:Image = new Image('graphics/ui-arrow.jpg');
        arrowLeft.scrollX = 0;
        arrowLeft.alpha = 0.6;
        var arrowRight:Image = new Image('graphics/ui-arrow.jpg');
        arrowRight.scrollX = 0;
        arrowRight.alpha = 0.6;
        arrowRight.flipped = true;
        // add bitmaps that will stay in the same place mofo
        var punch:Image = new Image('graphics/ui-punch.png');
        punch.scrollX = 0;
        punch.alpha = 0.6;
        var kick:Image = new Image('graphics/ui-kick.png');
        kick.scrollX = 0;
        kick.alpha = 0.6;
        arrowRight.smooth = false;
        arrowLeft.smooth = false;
        kick.smooth = false;
        punch.smooth = false ;
        #end

        if (singlePlayer) {
            playertwo = new AIPlayer(Math.floor(650 * scaling), Math.floor(200 * scaling));
            //playerone.singlePlayer = true;
            #if mobile
            addGraphic(arrowRight, -4, halfWidth - 200 * scaling, arrowYOffset);
            addGraphic(arrowLeft, -4, 100* scaling, arrowYOffset);
            addGraphic(kick, -4, HXP.width - 200 * scaling, arrowYOffset);
            //addGraphic(punch, -4, halfWidth + 100* scaling, arrowYOffset);
            arrowRight.scale = scaling * 2;
            arrowLeft.scale = scaling * 2;
            kick.scale = scaling * 2;
            punch.scale = scaling * 2;
            #end
         } else {
            playertwo = new Player(Math.floor(650 * scaling), Math.floor(200 * scaling));
            playertwo.setKeysPlayer(Key.LEFT, Key.RIGHT, Key.SHIFT, Key.ENTER, 1);
            #if mobile
            arrowRight.scale = 0.6 * scaling * 2;
            arrowLeft.scale = 0.6 * scaling * 2;
            kick.scale = 0.6 * scaling * 2;
            punch.scale = 0.6 * scaling * 2;
            // player one

            addGraphic(arrowRight, -4, 150 * scaling, arrowYOffset);
            addGraphic(arrowLeft, -4, 50 * scaling, arrowYOffset);
            addGraphic(kick, -4, halfWidth - 100 * scaling, arrowYOffset);
            addGraphic(punch, -4, halfWidth - 200* scaling, arrowYOffset);

            // player two
            addGraphic(kick, -4, HXP.width - 100 * scaling, arrowYOffset);
            addGraphic(punch, -4, HXP.width - 200* scaling, arrowYOffset);
            addGraphic(arrowRight, -4, halfWidth + 150 * scaling, arrowYOffset);
            addGraphic(arrowLeft, -4, halfWidth + 50 * scaling, arrowYOffset);
            #end
        }
        healthTwo = new HealthBox(
            Std.int(halfWidth) + Std.int(healthOffset * scaling),
            topOffset
        );
        playertwo.setHealthBox(healthTwo);
        var mugshot2 = new Image("graphics/"+ chosenFighterTwo + "sm.png");
        mugshot2.scrollX = 0;
        mugshot2.scale = scaling;
        mugshot2.x = Std.int(halfWidth) + Std.int(healthOffset * scaling) + healthTwo.originalHealthWidth + 10;
        mugshot2.y = topOffset;
        mugshot2.smooth = false;
        addGraphic(mugshot2);
        var fighterTwoName = new Image("graphics/names/" + chosenFighterTwo + ".png");
        fighterTwoName.scrollX = 0;
        fighterTwoName.scale = scaling;
        fighterTwoName.x = Std.int(halfWidth) + Std.int(healthOffset * scaling) + healthTwo.originalHealthWidth - fighterTwoName.width;
        fighterTwoName.y = topOffset + Std.int(30 * scaling);
        fighterTwoName.smooth = false;
        addGraphic(fighterTwoName);

        playerone.setPlayer(chosenFighterOne);
        playertwo.setPlayer(chosenFighterTwo);

        add(healthTwo);
        add(healthOne);
        add(playerone);
        add(playertwo);

        var bgcolor:Int = 0xFFD42A;
        var roundBg = Image.createRect(Std.int(60 * scaling), Std.int(50 * scaling), bgcolor);
        roundBg.x = halfWidth - 25 * scaling;
        roundBg.y = topOffset;
        roundBg.scrollX = 0;
        addGraphic(roundBg);

        roundText = new RoundText(0, topOffset + Std.int(10 * scaling));
        roundText.layer = -1000;
		    roundText.updateRoundSign(Std.string(Math.round(roundTime)));
        add(roundText);

        playerone.setEnemy(playertwo, 0);
        playertwo.setEnemy(playerone, 1);

    }

    private function updateRoundTime()
    {
        if (roundTime > 0 && playertwo.fightingState != "dead" && playerone.fightingState != "dead")
        {
            roundTime -= HXP.elapsed;
        }
        roundText.updateRoundSign(Std.string(Math.round(roundTime)));
        if (roundTime < 0)
        {
            if (playerone.health > playertwo.health) {
                playertwo.fightingState = "dead";
            } else {
                playerone.fightingState = "dead";
            }
        }
    }

    private function soundFx () {
      if (playerone.impact || playertwo.impact &&
        !finished) {
          var list:Array<String> = ["impact0", "impact1", "impact2","punch0", "punch1", "punch2"];
          var sound = Math.round(Math.random() * 5);

          sfx.get(list[sound]).play(1);
        }

        if (finished) {
          sfx.get("dead").play(1);
        }
    }

    private function cameraFollow () {
        var xDist = Math.abs(playerone.x - playertwo.x);
        var xMax = Math.max(playerone.x, playertwo.x);
        var xMin = Math.min(playerone.x, playertwo.x);
        var oneDistToCamera = playerone.x - HXP.camera.x;
        var twoDistToCamera = playertwo.x - HXP.camera.x;
        var oneDistToScreen = HXP.screen.width + HXP.camera.x - playerone.x;
        var twoDistToScreen = HXP.screen.width + HXP.camera.x - playertwo.x;
        var xMinDistToCamera = Math.min(Math.abs(oneDistToCamera), Math.abs(twoDistToCamera));
        var xMinDistToScreen = Math.min(Math.abs(oneDistToScreen), Math.abs(twoDistToScreen));

        if (xDist < HXP.screen.width - HXP.screen.x &&
            xMax < maxWidth &&
            xMinDistToScreen < 280 * scaling) {
                HXP.camera.x += 10 * scaling;
         }

         if (xDist < HXP.screen.width &&
            xMin > HXP.screen.x &&
            xMinDistToCamera < 50 * scaling &&
            HXP.camera.x >= HXP.screen.x) {
                HXP.camera.x -= 10 * scaling;
         }

         playerone.clampHorizontal(
           HXP.camera.x,
           HXP.screen.width + HXP.camera.x,
           30 * scaling);
         playertwo.clampHorizontal(
           HXP.camera.x,
           HXP.screen.width + HXP.camera.x,
           30 * scaling);

         if (HXP.camera.x < 0) {
           HXP.camera.x = 0;
         }
         if (HXP.camera.x + HXP.screen.width > maxWidth) {
           HXP.camera.x = maxWidth - HXP.screen.width;
         }
    }


    public override function update () {
        cameraFollow();
        playerone.clampHorizontal(0, maxWidth, 50 * scaling);
        playertwo.clampHorizontal(0, maxWidth, 50 * scaling);

        if (playerone.fightingState == "dead"){
          finished = true;
          // deadText.text = "Player one, you died.";
          // deadTextEntity.visible = true;
          // deadText.font = font.fontName;
          deadTime += HXP.elapsed;
        }
        if (playertwo.fightingState == "dead"){
          finished = true;
          // deadText.text = "Player two, you died.";
          // deadText.font = font.fontName;
          // deadTextEntity.visible = true;
          deadTime += HXP.elapsed;
        }

        if (deadTime > 3) {
            HXP.scene = new scenes.TitleScreen();
        }

        super.update();
        soundFx();
        if (playerone.impact && !finished) {
            ec.impact(playerone.x + 150 * scaling, playerone.y + 60 * scaling);
        }
        if (playertwo.impact && !finished) {
            ec.impact(playertwo.x + 150 * scaling, playertwo.y + 60 * scaling);
        }

        // quasi physics
        if (playerone.y < 200 * scaling) {
            playerone.y += 10;
        }
        if (playertwo.y < 200 * scaling) {
            playertwo.y += 10;
        }

        if (Input.pressed(Key.ESCAPE)) {
            HXP.scene = new scenes.TitleScreen();
        }
        updateRoundTime();
    }
}
