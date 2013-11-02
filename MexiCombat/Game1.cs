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
		private Sprite fighterTwo;
		// Keyboard states used to determine key presses
		KeyboardState currentKeyboardState;
		KeyboardState previousKeyboardState;

		// Gamepad states used to determine button presses
		GamePadState gamePadOneState;
		GamePadState gamePadTwoState;

		public string direction;
		private int viewport;

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
			fighterOne.Left = Keys.Left;
			fighterOne.Right = Keys.Right;
			fighterOne.Up = Keys.Up;
			fighterOne.Down = Keys.Down;
			fighterTwo = new Sprite(Content, "bigsprites.png", 4, 4, 3);
			fighterTwo.Left = Keys.A;
			fighterTwo.Right = Keys.D;
			fighterTwo.Up = Keys.W;
			fighterTwo.Down = Keys.S;
			fighterTwo.currentFrame = 4;
			fighterTwo.Position.X = 500;
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
			gamePadOneState = GamePad.GetState(PlayerIndex.One);
			gamePadTwoState = GamePad.GetState(PlayerIndex.Two);


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
			viewport = GraphicsDevice.Viewport.Width;
			fighterOne.Update(gameTime, gamePadOneState, currentKeyboardState, viewport);
			fighterTwo.Update(gameTime, gamePadTwoState, currentKeyboardState, viewport);
		}



		/// <summary>
		/// This is called when the game should draw itself.
		/// </summary>
		/// <param name="gameTime">Provides a snapshot of timing values.</param>
		protected override void Draw (GameTime gameTime)
		{
			graphics.GraphicsDevice.Clear (Color.CornflowerBlue);

			spriteBatch.Begin();

			spriteBatch.Draw(background, Vector2.Zero, Color.White);
			fighterOne.Draw(spriteBatch);
			fighterTwo.Draw(spriteBatch);

			spriteBatch.End();
		
            
			base.Draw (gameTime);
		}
	}
}

