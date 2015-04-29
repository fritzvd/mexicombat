package entities;

import openfl.Assets;
import com.haxepunk.Entity;
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

	public function new (x:Int, y:Int) {
		super(x, y);
		textEnsemble = new Graphiclist();
		graphic = textEnsemble;
	}
	
	public function setText (text:String, ?options:OutlineOptions) {
		
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
		var centerText:Text = new Text(text, textOptions);

		if (options.border) {
			var shadowOptions = {
				color: options.borderColor,
				size: options.size + options.borderSize,
				font: font.fontName
			}
			var shadow1 = new Text(text, shadowOptions);
			shadow1.x - options.borderSize;
			textEnsemble.add(shadow1);
			var shadow2 = new Text(text, shadowOptions);
			shadow2.x + options.borderSize;
			textEnsemble.add(shadow2);
			var shadow3 = new Text(text, shadowOptions);
			shadow3.y - options.borderSize;
			textEnsemble.add(shadow3);
			var shadow4 = new Text(text, shadowOptions);
			shadow4.y + options.borderSize;
			textEnsemble.add(shadow4);
		}

		centerText.x += options.borderSize / 2.0;
		centerText.y += options.borderSize / 2.0;
		textEnsemble.add(centerText);
	}
}
