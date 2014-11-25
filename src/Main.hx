import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;
import openfl.display.StageQuality;

class Main extends Engine
{
    public var plays:Int;
    public var scaling:Float;
    public var music:Sfx;

	override public function init()
	{
        //HXP.stage.smoothing = false;
#if debug
		HXP.console.enable();
#end        
        scaling = HXP.windowWidth / 1024;
        plays = 0;
        HXP.scene = new scenes.TitleScreen();
        HXP.stage.quality = StageQuality.LOW;
        music = new Sfx("audio/letmego.ogg");   
        music.loop();
	}

	public static function main() {
    
        // #if android
        // #end
        // music.loop();
        // 
        new Main(); 

    }

}
