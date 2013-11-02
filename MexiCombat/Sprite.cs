using System;
using System.Collections.Generic;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;


namespace MexiCombat
{
	public class Sprite
	{
		private Texture2D spriteTexture;
		public int Rows {get; set;}
		public int Columns {get; set;}
		public Vector2 Position;
		public int currentFrame;
		public int frameTime;
		public float speed;
		public int width;
		public int height;
		public Keys Left;
		public Keys Right;
		public Keys Up;
		public Keys Down;
		private int[] frameBounds;
		public int elapsedTime;
		
		public string FighterState;

		public Sprite (ContentManager contentManager, string assetTitle, int rows, int columns, float spriteSpeed)
		{
			spriteTexture = contentManager.Load<Texture2D>(assetTitle);
			Rows = rows;
			Columns = columns;
			currentFrame = 0;
			speed = spriteSpeed;
			frameTime = 100;
		}

		public void UpdateFrame (GameTime gameTime)
		{
			elapsedTime += (int)gameTime.ElapsedGameTime.TotalMilliseconds;
			if (elapsedTime > frameTime){
					currentFrame ++;
						if (currentFrame < frameBounds[0] || currentFrame > frameBounds[1] ) {
						currentFrame = frameBounds[0] + 1;
					}
					elapsedTime = 0;
				}

		}

		public void Update(GameTime gameTime, GamePadState currentGamePadState, KeyboardState currentKeyboardState, int viewPort)
		{
			// Get Thumbstick Controls
			Position.X += currentGamePadState.ThumbSticks.Left.X * speed;
			Position.Y -= currentGamePadState.ThumbSticks.Left.Y * speed;

			// Use the Keyboard / Dpad
			if (currentKeyboardState.IsKeyDown (Left) ||
				currentGamePadState.DPad.Left == ButtonState.Pressed) {
				Position.X -= speed;
				frameBounds = new int[] {4,7};
				this.UpdateFrame (gameTime);

			}
			if (currentKeyboardState.IsKeyDown (Right) ||
				currentGamePadState.DPad.Right == ButtonState.Pressed) {
				Position.X += speed;
				frameBounds = new int[] {8,11};
				this.UpdateFrame (gameTime);
			}
			if (currentKeyboardState.IsKeyDown (Up) ||
				currentGamePadState.DPad.Up == ButtonState.Pressed) {
				Position.Y -= speed *3;
				frameBounds = new int[] {12,15};
				this.UpdateFrame (gameTime);
			}
			if (currentKeyboardState.IsKeyDown (Down) ||
				currentGamePadState.DPad.Down == ButtonState.Pressed) {
				FighterState = "ducking";
			}
			// Make sure that the player does not go out of bounds
			Position.X = MathHelper.Clamp (Position.X, 0, viewPort - width);
			Position.Y = MathHelper.Clamp (Position.Y, 0, 380 - height);

			// Making sure player always falls back to:
			if (Position.Y < 250) {
				Position.Y += speed;
			}
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
		}
	}
}

