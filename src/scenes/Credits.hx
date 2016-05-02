package scenes;

import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;

class Credits extends TitleScreen {

  public override function begin() {
    super.begin();
    var splash = getInstance('splash');
    remove(splash);

    // add new menu item: back
    for (mi in menuItems) {
      remove(mi);
    }
    menuItems = [];
    addMenuItem('back');
    setCursor();

    // this is the widest of the images
    var chom = new Image('graphics/menu/chom.png');
    chom.scale = main.scaling;
    var x = HXP.halfWidth - chom.scaledWidth / 2;
    var marginTop = 150 * main.scaling;
    var tmp = addGraphic(new Image('graphics/menu/developer.png'), x, marginTop);
    var tmp = addGraphic(new Image('graphics/menu/fritzvd.png'), x, getHeightAndSetImgScale(tmp));
    var tmp = addGraphic(new Image('graphics/menu/graphics.png'), x, getHeightAndSetImgScale(tmp));
    var tmp = addGraphic(new Image('graphics/menu/Yoguruto.png'), x, getHeightAndSetImgScale(tmp));
    var tmp = addGraphic(new Image('graphics/menu/music.png'), x, getHeightAndSetImgScale(tmp));
    addGraphic(chom, x, getHeightAndSetImgScale(tmp));
  }

  private function getHeightAndSetImgScale (tmp:Entity) {
    var marginBetween = 10 * main.scaling;
    var img = cast(tmp.graphic, Image);
    var main = cast(HXP.engine, Main);
    img.scale = main.scaling;
    return tmp.y + img.scaledHeight + marginBetween;
  }

  private override function startNext(clicked:Entity)
  {
    switch(clicked.name) {
      case 'back':
      HXP.scene = new TitleScreen();
    }
  }
}
