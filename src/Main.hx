import com.haxepunk.Engine;
import com.haxepunk.HXP;


class Main extends Engine
{
    // public var plays:Int;

	override public function init()
	{
#if debug
		HXP.console.enable();
#end
        // HXP.scene = new scenes.PickCharacterScene();
        HXP.scene = new scenes.TitleScreen();
	}

	public static function main() { new Main(); }

}