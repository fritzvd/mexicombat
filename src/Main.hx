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
        //HXP.stage.smoothing = false;
#if debug
		HXP.console.enable();
#end        
        //scaling = HXP.windowWidth / 1024;
		scaling = 1;
		this.scaleX = HXP.windowWidth / 1024;
		this.scaleY = HXP.windowHeight / 640;
#if ios
		this.scaleX = this.scaleX / 2;
		this.scaleY = this.scaleY / 2;
#end
        plays = 0;
        HXP.scene = new scenes.TitleScreen();
        //music = new Sfx("audio/thisvalley8bit.wav");   
        //music.loop();
	}

	public static function main() {
    
        // #if android
        // #end
        // music.loop();
        // 
        new Main(); 

    }

}
