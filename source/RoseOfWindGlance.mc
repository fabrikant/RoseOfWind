import Toybox.System;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Application;
import Toybox.Time;
import Toybox.Lang;

(:glance)
class RoseOfWindGlance extends WatchUi.GlanceView {
  var wind_bitmap;

  function initialize() {
    CurrentOWM.startRequest(self.method(:onWeatherUpdate));
    wind_bitmap = null;
    GlanceView.initialize();
  }

  function onUpdate(dc) {
    dc.clear();
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    //dc.drawRectangle(0, 0, dc.getWidth(), dc.getHeight());

    var weather = Application.Storage.getValue(Global.KEY_CURRENT);
    if (weather == null) {
      dc.drawText(
        dc.getWidth() / 2,
        dc.getHeight() / 2,
        Graphics.FONT_GLANCE,
        Application.loadResource(Rez.Strings.NoData),
        Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
      );
    } else {
      drawGlance(dc, weather);
    }
  }

  function drawGlance(dc, data) {
    var color = Graphics.COLOR_WHITE;
    dc.setColor(color, Graphics.COLOR_TRANSPARENT);
    var font = Graphics.FONT_GLANCE;
    var font_h = Graphics.getFontHeight(font);
    var temp_y = 0;

    //condition
    dc.drawText(
      0,
      temp_y,
      font,
      data[Global.KEY_DESCRIPTION],
      Graphics.TEXT_JUSTIFY_LEFT
    );
    temp_y += font_h;
    var temp_x = 0;
    var rez = CommonOWM.findOWMResByCode(
      data[Global.KEY_ID],
      data[Global.KEY_ICON]
    );

    //image
    if (rez != null) {
      var bitmap = Global.createImage(rez, color);

      temp_y += (dc.getHeight() - temp_y - bitmap.getHeight()) / 2;

      dc.drawBitmap(0, temp_y, bitmap);
      font = Graphics.getVectorFont({
        :face => Global.vectorFontName(),
        :size => bitmap.getHeight(),
      });
      font_h = bitmap.getHeight();
      temp_x += bitmap.getWidth() * 1.2;
    }

    //temperature
    var str = Global.convertTemperature(data[Global.KEY_TEMP]);
    dc.drawText(temp_x, temp_y, font, str, Graphics.TEXT_JUSTIFY_LEFT);
    temp_x += dc.getTextWidthInPixels(str, font);

    //wind arrow
    var wind_angle = data[Global.KEY_WIND_DEG];
    if (wind_angle != null) {
      if (wind_bitmap == null) {
        wind_bitmap = Global.getWindArrowImage(font_h, color);
      }

      if (wind_bitmap instanceof Graphics.BufferedBitmapReference) {
        var transform = new Graphics.AffineTransform();
        transform.rotate((2 * Math.PI * (wind_angle + 180)) / 360f);
        transform.translate(
          -wind_bitmap.getWidth() / 2f,
          -wind_bitmap.getHeight() / 2f
        );

        var arrow_x = temp_x + font_h / 2;
        var arrow_y = temp_y + font_h / 2;
        dc.drawBitmap2(arrow_x, arrow_y, wind_bitmap, {
          :transform => transform,
          :filterMode => Graphics.FILTER_MODE_BILINEAR,
        });

        temp_x += font_h;

        font = Graphics.FONT_GLANCE;
        font_h =  Graphics.getFontHeight(font);
        dc.drawText(
          dc.getWidth(),
          dc.getHeight() - font_h,
          font,
          Global.converValueWindSpeed(data[Global.KEY_WIND_SPEED]),
          Graphics.TEXT_JUSTIFY_RIGHT
        );
      }
    }
  }

  function onWeatherUpdate(code, data) {
    if (code == 200) {
      CommonOWM.saveCurrentCondition(data);
      WatchUi.requestUpdate();
    }
  }
}
