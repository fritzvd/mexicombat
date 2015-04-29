package entities;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

class HealthBox extends Entity
{
    public var health:Int;
    private var rectImg:Image;
    public function new(x:Int, y:Int)
    {
        super(x, y);
        health = 100;
        rectImg = Image.createRect(health, 20, 0xDDDDDD);
		rectImg.scrollX = 0;
        graphic = rectImg;
    }

    public function updateHealth(h:Int)
    {
        health = h;

    }

    public override function update()
    {
        if (health < 1){
            scene.remove(this);
        } else {
            rectImg.scaledWidth = health;
        }
        super.update();
    }
}
