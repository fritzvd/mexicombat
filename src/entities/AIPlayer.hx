package entities;

import entities.Player;

class AIPlayer extends Player
{

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
		}
	}

	#if mobile
	public override function handleTouch()
	{
		ai();
	}
	#end 

	#if !mobile
	public override function handleInput()
	{
		ai();
	}
	#end

	public override function update()
	{
		super.update();
	}
}