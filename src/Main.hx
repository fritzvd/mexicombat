import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;

class Main extends Engine
{
    public var plays:Int;
    public var scaling:Float;
    public var music:Sfx;
    public var ASPECT:Float = 1.6;

	override public function init()
	{
#if debug
		HXP.console.enable();
#end

#if !html5
        resizeForAspect();
#end
        scaling = HXP.width / 1024;
        plays = 0;
        HXP.scene = new scenes.TitleScreen();
        HXP.screen.color = 0x000000;
        music = new Sfx("audio/caulfield8bit.ogg");
#if !debug
        music.loop(0.7);
#end
	}

    /**
    *
    * Function to calculate aspect and size (+ borders)
    * This is the "standard width"
    * 1024 * 640
    * The aspect is 16:10
    * So we need to calculate what the largest
    * version of that is on the screen we're displaying
    *
    */
    public function resizeForAspect () {
        var aspect = HXP.windowWidth / HXP.windowHeight;
        if (aspect > ASPECT) {
            var newWidth = Math.floor(HXP.windowHeight * ASPECT);
            var diff = newWidth - HXP.windowWidth;
            HXP.resize(newWidth, HXP.windowHeight);
            HXP.screen.x = Math.floor(Math.abs(diff) / 2);
            //this.scaleY = ASPECT / aspect;
        } else if (aspect < ASPECT) {
            var newHeight = Math.floor(HXP.windowWidth / ASPECT);
            var diff = HXP.windowHeight - newHeight;
            HXP.resize(HXP.windowWidth, newHeight);
            HXP.screen.y = Math.floor(diff / 2);

        }


    }

	public static function main() {
        new Main();
    }

}
