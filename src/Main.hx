import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;

class Main extends Engine
{
    public var plays:Int;
    public var scaling:Float;
    public var music:Sfx;
    public var ASPECT:Float;

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

        resizeForAspect();  
        scaling = HXP.width / 1024;
/*        this.scaleX = HXP.windowWidth / 1024;*/
        /*this.scaleY = HXP.windowHeight / 640;*/
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
            HXP.resize(HXP.windowWidth, newHeight);
        } else if (aspect < ASPECT) {
            var newWidth = Math.floor(HXP.windowHeight * ASPECT);
            HXP.resize(newWidth, HXP.windowHeight);
        }


    }

	public static function main() {
    
        // #if android
        // #end
        // music.loop();
        // 
        new Main(); 

    }

}
