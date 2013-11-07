package entities;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

class HealthBox extends Entity
{
    public var health:Int;
    public function new(x:Int, y:Int)
    {
        super(x, y);
        health = 100;
        graphic = Image.createRect(health, 20, 0xDDEEFF);
    }

    public function updateHealth(h:Int)
    {
        health = h;
    }

    public override function update()
    {
        graphic = Image.createRect(health, 20, 0xDDEEFF);
        super.update();
    }
}