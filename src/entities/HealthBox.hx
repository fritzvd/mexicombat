package entities;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.masks.Polygon;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Graphiclist;

class HealthBox extends Entity
{
    public var health:Int;
    private var healthWidth:Float;
    private var rectImg:Image;
    private var outerRect:Image;
    private var rectangle:Polygon;
    private var healthBox:Graphiclist;
    private var flip:Bool = false;
    private var color:Int = 0xFFD42A;

    public function new(x:Int, y:Int)
    {
        super(x, y);
        health = 100;
        healthWidth = (HXP.windowWidth * 0.4) * health / 100;

        rectangle = Polygon.createFromArray([
                0.0, 0.0,
                0.0, 28.0,
                healthWidth + 8, 28.0,
                healthWidth + 8, 0.0,
                ]);
        outerRect = Image.createPolygon(rectangle, 0x000000, 1, false, 1);
        outerRect.x -= 2;
        outerRect.y -= 2;
        outerRect.scrollX = 0;

        rectImg = Image.createRect(Std.int(healthWidth), 20, color);
		rectImg.scrollX = 0;
        
        healthBox = new Graphiclist();
        healthBox.add(outerRect);
        healthBox.add(rectImg);
        graphic = healthBox;
    }

    public function flipped () {
        rectImg.originX = 100;
        rectImg.x = 100;
        flip = true;
        rectImg.scrollX = 0;
    }

    public function updateHealth(h:Int)
    {
        health = h;
        healthWidth = (HXP.windowWidth * 0.4) * health / 100;
    }

    public override function update()
    {
        if (health < 1){
            scene.remove(this);
        } else if (!flip){
            rectImg.scaledWidth = healthWidth;
        } else {
            healthBox.removeAt(1);
            rectImg = Image.createRect(Std.int(healthWidth), 20, color);
            healthBox.add(rectImg);
            flipped();
        }
        super.update();
    }
}
