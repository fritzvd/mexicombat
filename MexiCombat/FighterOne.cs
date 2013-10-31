using System;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework.Graphics;

namespace MexiCombat
{
	public class FighterOne : AnimatedSprite
	{
        const string FIGHTER_ASSETNAME = "WizardSquare";
        const int START_POSITION_X = 125;
        const int START_POSITION_Y = 245;
        const int WIZARD_SPEED = 160;
        const int MOVE_UP = -1;
        const int MOVE_DOWN = 1;
        const int MOVE_LEFT = -1;
        const int MOVE_RIGHT = 1;

		public FighterOne (Texture2D texture, int rows, int columns)
		{
			Texture = texture;
			Rows = rows;
			Columns = columns;

		}
	}
}

