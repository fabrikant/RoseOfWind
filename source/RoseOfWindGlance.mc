import Toybox.System;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Application;
import Toybox.Time;
import Toybox.Lang;

(:glance)
class RoseOfWindGlance extends WatchUi.GlanceView {
  var wind_bitmap;
  var update_error;

  function initialize() {
    CurrentOWM.startRequest(self.method(:onWeatherUpdate));
    wind_bitmap = null;
    update_error = null;
    GlanceView.initialize();
  }

  function onUpdate(dc) {
    var weather = Application.Storage.getValue(Global.KEY_CURRENT);
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
    dc.clear();

    var owm_key = Application.Properties.getValue("keyOW");
    if (owm_key.equals("")) {
      var str = Graphics.fitTextToArea(
        Application.loadResource(Rez.Strings.InputKey),
        Graphics.FONT_GLANCE,
        dc.getWidth() ,
        dc.getHeight(),
        Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
      );
      dc.drawText(
        dc.getWidth() / 2,
        dc.getHeight() / 2,
        Graphics.FONT_GLANCE,
        str,
        Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
      );
    } else if (update_error != null) {
      dc.drawText(
        0,
        0,
        Graphics.FONT_GLANCE,
        "error code: " + update_error[:code].toString(),
        Graphics.TEXT_JUSTIFY_LEFT
      );
      if (update_error[:data] != null) {
        dc.drawText(
          0,
          Graphics.getFontHeight(Graphics.FONT_GLANCE),
          Graphics.FONT_GLANCE,
          update_error[:data],
          Graphics.TEXT_JUSTIFY_LEFT
        );
      }
    } else if (weather == null) {
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
    var color_bkgnd = Graphics.COLOR_BLACK;
    dc.setColor(color, color_bkgnd);
    dc.clear();
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
      var bitmap = Application.loadResource(rez);

      temp_y += (dc.getHeight() - temp_y - bitmap.getHeight()) / 2;

      dc.drawBitmap(0, temp_y, bitmap);
      font = Graphics.getVectorFont({
        :face => Global.vectorFontName(),
        :size => bitmap.getHeight(),
      });
      font_h = bitmap.getHeight();
      temp_x += bitmap.getWidth();
    }

    //temperature
    dc.setColor(
      Global.getTempColor(data[Global.KEY_TEMP], color),
      Graphics.COLOR_TRANSPARENT
    );
    var max_l_temp = dc.getTextWidthInPixels("-40°", font);
    var str = Global.convertTemperature(data[Global.KEY_TEMP]);
    dc.drawText(
      temp_x + max_l_temp / 2,
      temp_y,
      font,
      str,
      Graphics.TEXT_JUSTIFY_CENTER
    );
    temp_x += max_l_temp;
    dc.setColor(color, Graphics.COLOR_TRANSPARENT);

    //wind arrow
    var wind_angle = data[Global.KEY_WIND_DEG];
    if (wind_angle != null) {
      var wind_color = Global.getWindColor(data[Global.KEY_WIND_SPEED], color);
      if (wind_bitmap == null) {
        wind_bitmap = Global.getWindArrowImage(font_h * 0.6, wind_color);
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
        font_h = Graphics.getFontHeight(font);
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
          dc.getWidth(),
          arrow_y,
          font,
          Global.converValueWindSpeed(data[Global.KEY_WIND_SPEED]),
          Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER
        );
      }
    }
  }

  function onWeatherUpdate(code, data) {
    if (code == 200) {
      CommonOWM.saveCurrentCondition(data);
    } else {
      CommonOWM.saveCurrentCondition(null);
      update_error = {
        :code => code,
        :data => data["message"],
      };
    }
    WatchUi.requestUpdate();
  }
}
