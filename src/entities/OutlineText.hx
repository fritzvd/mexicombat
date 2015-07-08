package entities;

import openfl.Assets;
import com.haxepunk.Entity;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.graphics.Text;
import com.haxepunk.graphics.Graphiclist;

typedef OutlineOptions = {
	@:optional var border:Bool;
	
	@:optional var borderSize:Int;

	@:optional var borderColor:Int;

	@:optional var color:Int;

	@:optional var size:Int;
}

class OutlineText extends Entity
{

	private var textEnsemble:Graphiclist;

    private var centerText:Text;
    private var shadow1:Text;
    private var shadow2:Text;
    private var shadow3:Text;
    private var shadow4:Text;
    private var text:String;
    private var changed:Bool;

	public function new (x:Int, y:Int) {
		super(x, y);
		textEnsemble = new Graphiclist();
		graphic = textEnsemble;
	}


	public function setText (_text:String, ?options:OutlineOptions) {
        text = _text;
		
		if(!Reflect.hasField(options, "border")) options.border = false;
		if(!Reflect.hasField(options, "borderSize")) options.borderSize = 1;
		if(!Reflect.hasField(options, "borderColor")) options.borderColor = 0x000000;
		if(!Reflect.hasField(options, "color")) options.color = 0xFFFFFF;
		if(!Reflect.hasField(options, "size")) options.size = 30;

		var font = Assets.getFont('font/Fixedsys500c.ttf');
		var textOptions =  {
			color: options.color,
			size: options.size,
			font: font.fontName
		};
		centerText = new Text(text, textOptions);

		if (options.border) {
			var shadowOptions = {
				color: options.borderColor,
				size: options.size + options.borderSize,
				font: font.fontName
			}
			shadow1 = new Text(text, shadowOptions);
			shadow1.x -= options.borderSize;
			textEnsemble.add(shadow1);
            shadowOptions.color = 0xFF2200;
			shadow2 = new Text(text, shadowOptions);
			shadow2.x += options.borderSize;
			textEnsemble.add(shadow2);
            shadowOptions.color = 0x22FF00;
			shadow3 = new Text(text, shadowOptions);
			shadow3.y -= options.borderSize;
			textEnsemble.add(shadow3);
            shadowOptions.color = 0x0000FF;
			shadow4 = new Text(text, shadowOptions);
			shadow4.y += options.borderSize;
			textEnsemble.add(shadow4);
		}

		centerText.x += options.borderSize / 2.0;
		centerText.y += options.borderSize / 2.0;
        textEnsemble.add(centerText);
	}

    public function updateText(_text:String) {
        text = _text;
        centerText.text = text;
        shadow1.text = text;
        shadow2.text = text;
        shadow3.text = text;
        shadow4.text = text;
    }
	
    public override function update () {
        if (Input.pressed(Key.G)) {
            trace("this", x);
            trace("center", centerText.x);
            trace("shadow1", shadow1.x);
            trace("shadow2", shadow2.x);
        }

    }
}
