package scenes;

import com.haxepunk.Scene;
import com.haxepunk.utils.Key;
import entities.Player;
import entities.HealthBox;

class GameScene extends Scene
{
    public function new()
    {
        super();
    }

    public override function begin()
    {
        playerone = new Player(200, 250);
        playerone.setKeysPlayer(Key.A, Key.D, 0);
        playerone.setHealthBox(new HealthBox(100, 50));
        playertwo = new Player(400, 250);
        playertwo.setKeysPlayer(Key.LEFT, Key.RIGHT, 1);
        playertwo.setHealthBox(new HealthBox(300, 50));
    }
}