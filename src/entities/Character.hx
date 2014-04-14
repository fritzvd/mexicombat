package entities;

import com.haxepunk.graphics.Image;
import com.haxepunk.Entity;
import com.haxepunk.HXP;

class Character extends Entity
{

    private var mugshot:Image;

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
        mugshot = new Image("graphics/" + characterName + ".png");
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