using System;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework;

namespace MexiCombat
{
	public class AnimatedSprite
	{
		public Texture2D Texture {get; set;}
		public int Rows {get; set;}
		public int Columns {get; set;}
		public int currentFrame;
		public int totalFrames;

		public AnimatedSprite (Texture2D texture, int rows, int columns)
		{
			Texture = texture;
			Rows = rows;
			Columns = columns;
			currentFrame = 0;
			totalFrames = Rows * Columns;
		}

		public void Update ()
		{
			currentFrame ++;
				if (totalFrames == currentFrame){
				currentFrame = 0;
			}
		}

		public void Draw (SpriteBatch spriteBatch, Vector2 location)
		{
			int width = Texture.Width / Columns;
			int height = Texture.Height / Rows;
			int row	= (int)((float)currentFrame	/ (float)Columns);
			int column = currentFrame % Columns;

			Rectangle sourceRectangle = new Rectangle(width * column, height * row, width, height);
			Rectangle destinationRectangle = new Rectangle((int)location.X, (int)location.Y, width, height);

//			spriteBatch.Begin();
			spriteBatch.Draw (Texture, destinationRectangle, sourceRectangle, Color.AliceBlue);
			spriteBatch.End();
		}
	}
}

