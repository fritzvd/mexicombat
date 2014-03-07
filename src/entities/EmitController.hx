package entities;

import com.haxepunk.graphics.Emitter;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Ease;
import com.haxepunk.Entity;

class EmitController extends Entity
{
	private var _emitter:Emitter;

	public function new()
	{
		super(x, y);
		// var circle:Image = Image.createCircle(3);
        _emitter = new Emitter("graphics/particle.png", 4, 4);
        _emitter.newType("impact", [0]);
        _emitter.setMotion("impact",  		// name
		        	0, 				// angle
		        	100, 			// distance
		        	2, 				// duration
		        	360, 			// ? angle range
		        	-40, 			// ? distance range
		        	1, 				// ? Duration range
		        	Ease.quadOut	// ? Easing	
		        	);
        _emitter.setAlpha("impact", 20, 0.1);
        _emitter.setGravity("impact", 5, 1);
        // emitEnergy.render("thisOne", x,y);
        graphic = _emitter;
        layer = -1;
	}

	public function impact(x:Float, y:Float)
	{
		for (i in 0...20)
		{
			_emitter.emit("impact", x, y);
		}
	}


}
