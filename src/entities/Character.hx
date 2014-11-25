package entities;

import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Entity;
import com.haxepunk.HXP;

class Character extends Entity
{

    private var mugshot:Spritemap;

    public var selected:Bool;

    public function new(x:Float=0, y:Float=0)
    {
        super(x, y);
        selected = false;
    }

    public function set(characterName:String)
    {
        var main = cast(HXP.engine, Main);
        name = characterName;
        type = "character";
        mugshot = new Spritemap("graphics/"+ characterName + ".png", 200, 200);
        mugshot.add("idle", [0, 1, 2], 12);
        mugshot.play("idle");
        mugshot.scale = 0.3 * main.scaling;
        width = Math.round(mugshot.width * mugshot.scale);
        height = Math.round(mugshot.height * mugshot.scale);
        graphic = mugshot;
    }

    public function select()
    {
        selected = true;
    }

    public function unselect()
    {
        selected = false;
    }

    private function selectedBox()
    {
        if (selected) {
            //draw big ass sprite
        }
    
    }

    public override function update()
    {
        selectedBox();
        super.update();
    }
}
