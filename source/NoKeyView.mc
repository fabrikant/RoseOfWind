import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;

class NoKeyView extends WatchUi.View {
  function initialize() {
    View.initialize();
  }

  function onUpdate(dc) {
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
    dc.clear();
    var owm_key = Application.Properties.getValue("keyOW");
    if (owm_key.equals("")) {
      var font_size = dc.getHeight() * 0.1;
      var font = Graphics.getVectorFont({
        :face => Global.vectorFontName(),
        :size => font_size,
      });
      var str =
        Application.loadResource(Rez.Strings.InputKey) +
        "\n" +
        Application.loadResource(Rez.Strings.Lat) +
        ": " +
        Application.Properties.getValue("Lat") +
        "\n" +
        Application.loadResource(Rez.Strings.Lon) +
        ": " +
        Application.Properties.getValue("Lon");

      str = Graphics.fitTextToArea(
        str,
        font,
        dc.getWidth() * 0.7,
        dc.getHeight(),
        Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
      );
      dc.drawText(
        dc.getWidth() / 2,
        dc.getHeight() / 2,
        font,
        str,
        Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
      );
    } else {
      var str = Lang.format("$1$:\n$2$", [
        Application.loadResource(Rez.Strings.InputKey),
        owm_key,
      ]);
      dc.drawText(
        dc.getWidth() / 2,
        dc.getHeight() / 2,
        Graphics.FONT_SYSTEM_LARGE,
        str,
        Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
      );
    }
  }
}

class NoKeyDelegate extends WatchUi.BehaviorDelegate {
  public function initialize() {
    BehaviorDelegate.initialize();
  }

  public function onSelect() {
    //криво работает ввод через телефон. теряется последний знак
    return;
    WatchUi.pushView(
      new WatchUi.TextPicker(Application.Properties.getValue("keyOW")),
      new TextDelegate("keyOW"),
      WatchUi.SLIDE_UP
    );
    return true;
  }
}
