import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;

class Main extends Engine
{
    public var plays:Int;
    public var scaling:Float;
    public var music:Sfx;

	override public function init()
	{
#if debug
		HXP.console.enable();
#end        
        scaling = HXP.windowWidth / 1024;
        plays = 0;
        music = new Sfx("audio/letmego.ogg");   
        music.loop();
        HXP.scene = new scenes.TitleScreen();
	}

	public static function main() {
    
        // #if android
        // #end
        // music.loop();
        // 
        new Main(); 

    }

}