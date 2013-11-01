#region Using Statements
using System;

using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Storage;
using Microsoft.Xna.Framework.Input;

#endregion

namespace MexiCombat
{
	/// <summary>
	/// This is the main type for your game
	/// </summary>
	public class Game1 : Game
	{
		GraphicsDeviceManager graphics;
		SpriteBatch spriteBatch;
		
		private Texture2D background;
		private Sprite fighterOne;
		// Keyboard states used to determine key presses
		KeyboardState currentKeyboardState;
		KeyboardState previousKeyboardState;

		// Gamepad states used to determine button presses
		GamePadState currentGamePadState;
		GamePadState previousGamePadState;


		public Game1 ()
		{
			graphics = new GraphicsDeviceManager (this);
			Content.RootDirectory = "Content";	            
			graphics.IsFullScreen = false;		
		}

		/// <summary>
		/// Allows the game to perform any initialization it needs to before starting to run.
		/// This is where it can query for any required services and load any non-graphic
		/// related content.  Calling base.Initialize will enumerate through any components
		/// and initialize them as well.
		/// </summary>
		protected override void Initialize ()
		{
			base.Initialize ();
		}

		/// <summary>
		/// LoadContent will be called once per game and is the place to load
		/// all of your content.
		/// </summary>
		protected override void LoadContent ()
		{
			// Create a new SpriteBatch, which can be used to draw textures.
			spriteBatch = new SpriteBatch (GraphicsDevice);

			background = Content.Load<Texture2D>("bg.png");
			fighterOne = new Sprite(Content, "bigsprites.png", 4, 4, 3);
		}

		/// <summary>
		/// Allows the game to run logic such as updating the world,
		/// checking for collisions, gathering input, and playing audio.
		/// </summary>
		/// <param name="gameTime">Provides a snapshot of timing values.</param>
		protected override void Update (GameTime gameTime)
		{
			previousKeyboardState = currentKeyboardState;
			currentKeyboardState = Keyboard.GetState();
			previousGamePadState = currentGamePadState;
			currentGamePadState = GamePad.GetState(PlayerIndex.One);

			if (GamePad.GetState (PlayerIndex.One).Buttons.Back == ButtonState.Pressed) {
				Exit ();
			} else if (Keyboard.GetState().IsKeyDown(Keys.Escape)) {
				Exit ();
			}

			base.Update (gameTime);
			UpdatePlayer(gameTime);

		}

		private void UpdatePlayer (GameTime gameTime)
		{
			// Get Thumbstick Controls
			fighterOne.Position.X += currentGamePadState.ThumbSticks.Left.X *fighterOne.speed;
			fighterOne.Position.Y -= currentGamePadState.ThumbSticks.Left.Y *fighterOne.speed;

			// Use the Keyboard / Dpad
			if (currentKeyboardState.IsKeyDown(Keys.Left) ||
			currentGamePadState.DPad.Left == ButtonState.Pressed)
			{
				fighterOne.Position.X -= fighterOne.speed;
				fighterOne.currentFrame ++;
					if (fighterOne.currentFrame < 4|| fighterOne.currentFrame > 7 ) {
					fighterOne.currentFrame = 5;
				}
			}
			if (currentKeyboardState.IsKeyDown(Keys.Right) ||
			currentGamePadState.DPad.Right == ButtonState.Pressed)
			{
				fighterOne.Position.X += fighterOne.speed;
				fighterOne.currentFrame ++;
					if (fighterOne.currentFrame < 8 || fighterOne.currentFrame > 11 ) {
					fighterOne.currentFrame = 9;
				}
			}
			if (currentKeyboardState.IsKeyDown(Keys.Down) ||
			currentGamePadState.DPad.Down == ButtonState.Pressed)
			{
				fighterOne.Position.Y += fighterOne.speed;
				fighterOne.currentFrame ++;
					if (fighterOne.currentFrame > 4) {
					fighterOne.currentFrame = 0;
				}
			}
			if (currentKeyboardState.IsKeyDown(Keys.Up) ||
			currentGamePadState.DPad.Up == ButtonState.Pressed)
			{
				fighterOne.Position.Y -= fighterOne.speed;
				fighterOne.currentFrame ++;
					if (fighterOne.currentFrame < 12 || fighterOne.currentFrame > 15 ) {
					fighterOne.currentFrame = 11;
				}
			}
			// Make sure that the player does not go out of bounds
			fighterOne.Position.X = MathHelper.Clamp(fighterOne.Position.X, 0,GraphicsDevice.Viewport.Width - fighterOne.width);
			fighterOne.Position.Y = MathHelper.Clamp(fighterOne.Position.Y, 0,GraphicsDevice.Viewport.Height - fighterOne.height);
		}

		/// <summary>
		/// This is called when the game should draw itself.
		/// </summary>
		/// <param name="gameTime">Provides a snapshot of timing values.</param>
		protected override void Draw (GameTime gameTime)
		{
			graphics.GraphicsDevice.Clear (Color.CornflowerBlue);

			spriteBatch.Begin();

			spriteBatch.Draw(background, new Rectangle(0, 0, 800, 480), Color.White);
			fighterOne.Draw(spriteBatch);

			spriteBatch.End();
		
            
			base.Draw (gameTime);
		}
	}
}

