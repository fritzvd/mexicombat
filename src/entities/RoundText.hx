package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.HXP;

class RoundText extends Entity
{

    private var roundTime:String;
	private var textEnsemble:Graphiclist;
    private var numberMap:Map<String, Image>;


	public function new (x:Int, y:Int) {
		super(x, y);
		textEnsemble = new Graphiclist();
		graphic = textEnsemble;

        numberMap = new Map();
        roundTime = "00";

        var main = cast(HXP.engine, Main);
        var scaling = main.scaling;
        
        for (i in 0...10) {
            var iStr = Std.string(i);
            var firstImg = new Image("graphics/numbers/" + iStr + ".png"); 
            firstImg.scrollX = 0;
            // can't get the numbers to display otherwise
            firstImg.relative = false;
            firstImg.x = HXP.windowWidth / 2 - 20 * scaling;
            firstImg.y = y;
            var secImg = new Image("graphics/numbers/" + iStr + ".png"); 
            secImg.scrollX = 0;
            secImg.x = HXP.windowWidth / 2 - 20 * scaling;
            secImg.y = y;
            secImg.relative = false;
            secImg.x += 20;
            numberMap.set("first" + i, firstImg);
            numberMap.set("sec" + i, secImg);
        }
        charSelector();
	}

    public function updateRoundSign(rT:String) {
        if (rT != roundTime) {
            if (Std.parseInt(rT) < 10) {
                rT = "0" + rT;
            }
            roundTime = rT;
            charSelector();
        }
    }
	
    private function charSelector() {
        var firstChar = roundTime.substr(0,1);
        var secChar = roundTime.substr(1,1);
        textEnsemble.removeAll();
        textEnsemble.add(numberMap.get("first" + firstChar));
        textEnsemble.add(numberMap.get("sec" + secChar));
    }

    //public override function update () {

    //}
}
