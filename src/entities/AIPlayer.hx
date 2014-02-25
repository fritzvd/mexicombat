package entities;

import com.haxepunk.HXP;
import entities.Player;

class AIPlayer extends Player
{
	private var oldTime:Float;
	private var newTime:Float;

	public override function new(x:Int, y:Int)
	{
		super(x, y);
		oldTime = 0;
		newTime = 0;
	}

	private function ai()
	{
		var rand:Float = Math.random();
		if (rand > 0.5) {
			acceleration = -2;
			if (rand < 0.75) {
				// do nothing
			} else {
				if (rand > 0.6) {
					fightingState = "punching";				
				} else {
					fightingState = "kicking";
				}
			}
		} else {
			acceleration = 2;
			if (rand < 0.25) {
				// do nothing
			} else {
				if (rand > 0.3) {
					fightingState = "punching";				
				} else {
					fightingState = "kicking";
				}
			}
		}
	}

	#if mobile
	public override function handleTouch(touch:com.haxepunk.utils.Touch)
	{
	}
	#end 

	#if !mobile
	public override function handleInput()
	{
	}
	#end

	public override function update()
	{
		newTime += HXP.elapsed;
		// trace(oldTime, newTime, HXP._gameTime);
		if (newTime > oldTime + 0.5) {
			oldTime = Std.int(newTime);
			ai();
		}
		super.update();
	}
}