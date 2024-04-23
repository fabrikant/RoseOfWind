import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Time;
import Toybox.Math;
import Toybox.System;

class RoseOfWindView extends WatchUi.View {
  var page, data;

  function initialize(page, data) {
    self.page = page;
    self.data = data;
    View.initialize();
  }

  function onUpdate(dc as Dc) as Void {
    if (data == null) {
      dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
      dc.clear();
      dc.drawText(
        dc.getWidth() / 2,
        dc.getHeight() / 2,
        Graphics.FONT_SYSTEM_LARGE,
        Application.loadResource(Rez.Strings.NoData),
        Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
      );
    } else {
      drawPage(dc);
    }
  }

  function drawPage(dc) {
    var color = Graphics.COLOR_WHITE;
    var color_bkgnd = Graphics.COLOR_BLACK;
    dc.setColor(color, color_bkgnd);
    dc.clear();

    var str = "";
    var font = Graphics.getVectorFont({
      :face => Global.vectorFontName(),
      :size => Math.floor(dc.getHeight() * 0.12).toNumber(),
    });
    var font_h = Graphics.getFontHeight(font);

    //*************************************************************************
    //condition
    var center = [dc.getWidth() / 2, dc.getHeight() / 2];
    dc.drawRadialText(
      center[0],
      center[1],
      font,
      data[Global.KEY_DESCRIPTION],
      Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER,
      90,
      center[1] - font_h / 2,
      Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE
    );

    //*************************************************************************
    //image
    var rez = BigImages.findOWMResByCode(
      data[Global.KEY_ID],
      data[Global.KEY_ICON]
    );

    var temp_y = font_h;
    if (rez != null) {
      var bitmap = Application.loadResource(rez);
      dc.drawBitmap(center[0] - bitmap.getWidth() / 2, temp_y, bitmap);
      temp_y += bitmap.getHeight();
    }

    //*************************************************************************
    //Temperature
    font = Graphics.getVectorFont({
      :face => Global.vectorFontName(),
      :size => Math.floor(dc.getHeight() * 0.2).toNumber(),
    });
    font_h = Graphics.getFontHeight(font);
    dc.setColor(Global.getTempColor(data[Global.KEY_TEMP], color), color_bkgnd);
    str = Global.convertTemperature(data[Global.KEY_TEMP]) + postfixTemp();
    dc.drawText(center[0] / 2, temp_y, font, str, Graphics.TEXT_JUSTIFY_CENTER);

    //*************************************************************************
    //Wind
    var wind_color = Global.getWindColor(data[Global.KEY_WIND_SPEED], color);
    var wind_bitmap = Global.getWindArrowImage(font_h * 0.9, wind_color);
    var wind_angle = data[Global.KEY_WIND_DEG];
    if (wind_bitmap instanceof Graphics.BufferedBitmapReference) {
      var transform = new Graphics.AffineTransform();
      transform.rotate((2 * Math.PI * (wind_angle + 180)) / 360f);
      transform.translate(
        -wind_bitmap.getWidth() / 2f,
        -wind_bitmap.getHeight() / 2f
      );

      var arrow_x = center[0] + font_h / 2;
      var arrow_y = temp_y + font_h / 2;
      dc.drawBitmap2(arrow_x, arrow_y, wind_bitmap, {
        :transform => transform,
        :filterMode => Graphics.FILTER_MODE_BILINEAR,
      });

      font = Graphics.getVectorFont({
        :face => Global.vectorFontName(),
        :size => Math.floor(dc.getHeight() * 0.1).toNumber(),
      });

      dc.setColor(color, color_bkgnd);
      dc.drawText(
        center[0] + font_h,
        arrow_y,
        font,
        Global.converValueWindSpeed(data[Global.KEY_WIND_SPEED]),
        Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
      );
    }

    //*************************************************************************
    //Decoration
    temp_y += font_h + 5;
    var temp_x1 = dc.getWidth() * 0.40;
    var y_offset = dc.getHeight() * 0.9;
    dc.setColor(Graphics.COLOR_DK_GRAY, color_bkgnd);
    dc.setPenWidth(5);
    dc.drawLine(temp_x1, temp_y, temp_x1, y_offset);
    dc.setColor(color, color_bkgnd);
    dc.setPenWidth(1);
    dc.drawLine(temp_x1, temp_y, temp_x1, y_offset);

    var temp_x2 = dc.getWidth() * 0.15;
    dc.setColor(Graphics.COLOR_DK_GRAY, color_bkgnd);
    dc.setPenWidth(5);
    dc.drawLine(temp_x2, temp_y, dc.getWidth() - temp_x2, temp_y);
    dc.setColor(color, color_bkgnd);
    dc.setPenWidth(1);
    dc.drawLine(temp_x2, temp_y, dc.getWidth() - temp_x2, temp_y);

    //*************************************************************************
    //Other values
    font = Graphics.getVectorFont({
      :face => Global.vectorFontName(),
      :size => Math.floor(dc.getHeight() * 0.1).toNumber(),
    });

    temp_y += 5;
    dc.setColor(color, color_bkgnd);

    str = Global.convertPressure(data[Global.KEY_PRESSURE]);
    var bitmap = Application.loadResource(Rez.Drawables.Pressure);
    dc.drawBitmap(temp_x1 - bitmap.getWidth() * 1.1, temp_y, bitmap);
    dc.drawText(temp_x1 + 5, temp_y, font, str, Graphics.TEXT_JUSTIFY_LEFT);

    temp_y += bitmap.getHeight() * 1.2;
    
    str =
      Global.convertTemperature(data[Global.KEY_TEMP_FEELS_LIKE]) +
      postfixTemp() +" "+Application.loadResource(Rez.Strings.Feels);
    bitmap = Application.loadResource(Rez.Drawables.Temperature);
    dc.drawBitmap(temp_x1 - bitmap.getWidth() * 1.1, temp_y, bitmap);
    dc.drawText(temp_x1 + 5, temp_y, font, str, Graphics.TEXT_JUSTIFY_LEFT);

    temp_y += bitmap.getHeight() * 1.2;
    
    str = Lang.format("$1$%", [data[Global.KEY_HUMIDITY]]);
    bitmap = Application.loadResource(Rez.Drawables.Humidity);
    dc.drawBitmap(temp_x1 - bitmap.getWidth() * 1.1, temp_y, bitmap);
    dc.drawText(temp_x1 + 5, temp_y, font, str, Graphics.TEXT_JUSTIFY_LEFT);

    //*************************************************************************
    //City and date
    dc.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_RED);

    var moment = new Time.Moment(data[Global.KEY_DT]);
    var info = Time.Gregorian.info(moment, Time.FORMAT_LONG);
    str = Lang.format("$6$ $1$, $2$ $3$ $4$:$5$", [
      info.day_of_week,
      info.day,
      info.month,
      info.hour.format("%02d"),
      info.min.format("%02d"),
      data[Global.KEY_CITY],
    ]);
    dc.drawRadialText(
      center[0],
      center[1],
      font,
      str,
      Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER,
      270,
      center[1] - Graphics.getFontHeight(font) / 2,
      Graphics.RADIAL_TEXT_DIRECTION_COUNTER_CLOCKWISE
    );
  }
}

function postfixTemp() {
  if (System.getDeviceSettings().temperatureUnits == System.UNIT_STATUTE) {
    return "F";
  } else {
    return "C";
  }
}
class RoseOfWindViewDelegate extends WatchUi.BehaviorDelegate {
  private var index;

  public function initialize(index) {
    BehaviorDelegate.initialize();
    self.index = index;
  }

  public function onSelect() {
    System.println("onSelect");
    // if (_index == 0) {
    //     WatchUi.pushView(new $.ApesView(), new $.DetailsDelegate(), WatchUi.SLIDE_UP);
    // } else if (_index == 1) {
    //     WatchUi.pushView(new $.MonkeysView(), new $.DetailsDelegate(), WatchUi.SLIDE_UP);
    // } else if (_index == 2) {
    //     WatchUi.pushView(new $.ProsimiansView(), new $.DetailsDelegate(), WatchUi.SLIDE_UP);
    // }
    return true;
  }
}
