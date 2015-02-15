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

        /**
         * This is the "standard width"
         * 1024 * 640
         * The aspect is 16:10 (that's weird huh?)
         * So we need to calculate what the largest
         * version of that is on the screen we're displaying
         *
         */

        trace(HXP.width, HXP.windowWidth, HXP.height, HXP.windowHeight);
        resizeForAspect();  
        trace(HXP.width, HXP.windowWidth, HXP.height, HXP.windowHeight);
        scaling = HXP.width / 1024;
#if ios
        this.scaleX = this.scaleX / 2;
        this.scaleY = this.scaleY / 2;
#end
        plays = 0;
        HXP.scene = new scenes.TitleScreen();
#if !debug
        music = new Sfx("audio/caulfield8bit.wav");   
        music.loop();
#end
	}

    public function resizeForAspect () {
        var aspect = HXP.windowWidth / HXP.windowHeight;
        if (aspect > ASPECT) {
            var newHeight = Math.floor(HXP.windowWidth / ASPECT);
            var diff = HXP.windowHeight - newHeight;
            HXP.resize(HXP.windowWidth, newHeight);
            HXP.screen.originY = Math.floor(diff / 2);
            //this.scaleY = ASPECT / aspect;
        } else if (aspect < ASPECT) {
            var newWidth = Math.floor(HXP.windowHeight * ASPECT);
            HXP.resize(newWidth, HXP.windowHeight);
            var diff = newWidth - HXP.windowWidth;
            trace(diff);
            HXP.screen.originX = Math.floor(diff / 2);
            HXP.screen.shake(1, 5.0);
            //this.scaleX = aspect / ASPECT;
        }


    }

	public static function main() { 
        new Main(); 
    }

}
