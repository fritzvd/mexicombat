using System;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Graphics;


namespace MexiCombat
{
	public class Sprite
	{
		private Texture2D spriteTexture;
		public int Rows {get; set;}
		public int Columns {get; set;}
		public Vector2 Position;
		public int currentFrame;
		public float speed;
		public int width;
		public int height;

		public Sprite (ContentManager contentManager, string assetTitle, int rows, int columns, float spriteSpeed)
		{
			spriteTexture = contentManager.Load<Texture2D>(assetTitle);
			Rows = rows;
			Columns = columns;
			currentFrame = 0;
			speed = spriteSpeed;
		}

		public void Draw (SpriteBatch spriteBatch)
		{
			width = spriteTexture.Width / Columns;
			height = spriteTexture.Height / Rows;
			int row	= (int)((float)currentFrame	/ (float)Columns);
			int column = currentFrame % Columns;

			Rectangle sourceRectangle = new Rectangle(width * column, height * row, width, height);
			Rectangle destinationRectangle = new Rectangle((int)Position.X, (int)Position.Y, width, height);

			spriteBatch.Draw(spriteTexture, destinationRectangle, sourceRectangle, Color.White);
			spriteBatch.End ();
		}
	}
}

