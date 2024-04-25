import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;

class UpdateErrorView extends WatchUi.View {
  var update_error;

  function initialize(update_error) {
    self.update_error = update_error;
    View.initialize();
  }

  function onUpdate(dc) {
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
    dc.clear();
    var font_size = dc.getHeight() * 0.1;
    var font = Graphics.getVectorFont({
      :face => Global.vectorFontName(),
      :size => font_size,
    });

    var y = font_size;
    var str = "error code:\n" + update_error[:code].toString();
    dc.drawText(dc.getWidth() / 2, y, font, str, Graphics.TEXT_JUSTIFY_CENTER);

    y += dc.getTextDimensions(str, font)[1];

    if (update_error[:data] != null) {
      dc.drawText(
        dc.getWidth() / 2,
        y,
        font,
        Graphics.fitTextToArea(
          update_error[:data],
          font,
          dc.getWidth() * 0.75,
          dc.getHeight(),
          Graphics.TEXT_JUSTIFY_CENTER
        ),
        Graphics.TEXT_JUSTIFY_CENTER
      );
    }
  }
}
