package;

import com.haxepunk.utils.Input;
import com.haxepunk.utils.Joystick.XBOX_GAMEPAD;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Touch;
import com.haxepunk.HXP;

class Inputs {

  static public var UP = 'UP';
  static public var DOWN = 'DOWN';
  static public var LEFT = 'LEFT';
  static public var RIGHT = 'RIGHT';

  static inline public function direction () {
    var _direction:String = '';

    if (Input.joystick(0).pressed(XBOX_GAMEPAD.DPAD_UP) ||
        Input.pressed(Key.W) || Input.pressed(Key.UP)) {
          _direction = UP; // pixel space move up y with -1
    }

    if (Input.joystick(0).pressed(XBOX_GAMEPAD.DPAD_DOWN) ||
        Input.pressed(Key.S) || Input.pressed(Key.DOWN)) {
          _direction = DOWN; // pixel space move down y with 1
    }

    if (Input.joystick(0).pressed(XBOX_GAMEPAD.DPAD_LEFT) ||
        Input.pressed(Key.A) || Input.pressed(Key.LEFT)) {
          _direction = LEFT; // pixel space move up x with -1
    }

    if (Input.joystick(0).pressed(XBOX_GAMEPAD.DPAD_RIGHT) ||
        Input.pressed(Key.D) || Input.pressed(Key.RIGHT)) {
          _direction = RIGHT; // pixel space move up x with 1
    }

    var XAXIS = Input.joystick(0).getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_X);
    var YAXIS = Input.joystick(0).getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_Y);

    if (XAXIS > 0.1) {
      _direction = RIGHT;
    }
    if (XAXIS < -0.1) {
      _direction = LEFT;
    }

    if (YAXIS > 0.1) {
      _direction = DOWN;
    }
    if (YAXIS < -0.1) {
      _direction = UP;
    }

    return _direction;
  }

  static inline public function action () {
    var _action:String = null;
#if !mobile
    if (Input.joystick(0).pressed(XBOX_GAMEPAD.A_BUTTON) ||
        Input.pressed(Key.Z)) {
          _action = 'forward';
    }

    if (Input.joystick(0).pressed(XBOX_GAMEPAD.B_BUTTON) ||
        Input.pressed(Key.X)) {
          _action = 'back';
    }
#end
    return _action;

  }



  static inline public function holding () {
    var _holding:String = null;

    if (Input.joystick(0).check(XBOX_GAMEPAD.A_BUTTON) ||
        Input.check(Key.Z)) {
          _holding = 'left';
    }

    if (Input.joystick(0).check(XBOX_GAMEPAD.B_BUTTON) ||
        Input.check(Key.X)) {
          _holding = 'right';
    }

    return _holding;
  }

  static inline public function shooting () {
    var _shooting:Bool = false;
    if (Input.joystick(0).pressed(XBOX_GAMEPAD.RB_BUTTON) ||
        Input.pressed(Key.SPACE)) {
          _shooting = true;
    }
    return _shooting;
  }

  static inline public function restart () {
    var _restart:Bool = false;
    if (Input.joystick(0).pressed(XBOX_GAMEPAD.START_BUTTON) ||
        Input.pressed(Key.SPACE)) {
          _restart = true;
    }
    return _restart;
  }

}
