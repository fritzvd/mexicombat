package entities;

import com.haxepunk.HXP;
import entities.Player;

class AIPlayer extends Player
{
	private var oldTime:Float;
	private var newTime:Float;
	private var randMove:Float;
	private var randWalk:Float;

	public override function new(x:Int, y:Int)
	{
		super(x, y);
		oldTime = 0;
		newTime = 0;
	}

	private function ai()
	{
		if (randMove > 0.5) {
			if (randMove < 0.75) {
				// do nothing
			} else {
				if (randMove > 0.6) {
					fightingState = "punching";
				} else {
					fightingState = "kicking";
				}
			}
		} else {
			if (randMove < 0.25) {
				// do nothing
			} else {
				if (randMove > 0.3) {
					fightingState = "punching";				
				} else {
					fightingState = "kicking";
				}
			}
		}
		if (randWalk > 0.3) {
			acceleration = 1;
		} else if (randWalk > 0.6){
			acceleration = -1;
		} else {
			acceleration = 0;
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
		if (newTime > oldTime + 0.5) {
			oldTime = Std.int(newTime);
			randMove = Math.random();
			randWalk = Math.random();
		}
		ai();
		move();
		super.update();
	}
}