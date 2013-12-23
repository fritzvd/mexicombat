import com.haxepunk.Engine;
import com.haxepunk.HXP;


class Main extends Engine
{
    public var plays:Int;
    public var scaling:Float;

	override public function init()
	{
#if debug
		HXP.console.enable();
#end
        
            scaling = HXP.windowWidth / 500;
            // trace(scaling);


        plays = 0;
        HXP.scene = new scenes.TitleScreen();
	}

	public static function main() { new Main(); }

}