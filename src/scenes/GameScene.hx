package scenes;

import com.haxepunk.Scene;
import com.haxepunk.utils.Key;
import entities.Player;
import entities.HealthBox;

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
        playerone = new Player(200, 250);
        playerone.setKeysPlayer(Key.A, Key.D, 0);
        healthOne = new HealthBox(100, 50);
        playerone.setHealthBox(healthOne);
        playertwo = new Player(400, 250);
        playertwo.setKeysPlayer(Key.LEFT, Key.RIGHT, 1);
        healthTwo = new HealthBox(300, 50);
        playertwo.setHealthBox(healthTwo);

        add(healthTwo);
        add(healthOne);
        add(playerone);
        add(playertwo);
    }

    public override function update()
    {
        playerone.setEnemyX(playertwo.x);
        playertwo.setEnemyX(playerone.x);
        super.update();
    }
}