package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;
import entities.Player;
import entities.HealthBox;

import com.haxepunk.graphics.Image;
import com.haxepunk.Entity;

class GameScene extends Scene
{

    private var playerone:Player;
    private var playertwo:Player;
    private var healthOne:HealthBox;
    private var healthTwo:HealthBox;
    public function new()
    {
        super();
    }

    public override function begin()
    {

        var bitmap:Image = new Image("graphics/bg.png");
        bitmap.x = - bitmap.width / 2;
        bitmap.y = - bitmap.height / 2;
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


        add(healthTwo);
        add(healthOne);
        add(playerone);
        add(playertwo);
    }

    public override function update()
    {
        playerone.setEnemyX(playertwo.x, playertwo.fightingState);
        playertwo.setEnemyX(playerone.x, playerone.fightingState);

        if (playerone.fightingState == "dead"){

        }

        if (Input.check(Key.ESCAPE)) {
            HXP.screen.color = 0x222233;
            HXP.scene = new scenes.TitleScreen();
        }
        super.update();
    }
}