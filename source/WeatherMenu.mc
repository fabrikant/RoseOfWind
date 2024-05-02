import Toybox.System;
import Toybox.Graphics;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class WeatherMenu extends WatchUi.CustomMenu {
  private var title_drawable;

  function initialize() {
    var item_h = System.getDeviceSettings().screenHeight / 4;
    title_drawable = new TitleDrawable(item_h / 2);
    title_drawable = CustomMenu.initialize(item_h, Graphics.COLOR_BLACK, {
      :title => title_drawable,
      :titleItemHeight => item_h / 2,
    });
    addItems();
    ForecastOWM.startRequest(self.method(:onWeatherUpdate));
  }

  function addItems() {
    var data = Application.Storage.getValue(Global.KEY_FORECAST);
    if (data instanceof Lang.Array) {
      for (var i = 0; i < data.size(); i++) {
        addItem(new WeatherMenuItem(i, data[i]));
      }
    }
  }

  function onWeatherUpdate(code, inet_data) {
    if (code == 200) {
      ForecastOWM.saveForecast(inet_data);
      var data = Application.Storage.getValue(Global.KEY_FORECAST);
      for (var i = 0; i < data.size(); i++) {
        var item = getItem(i);
        if (item != null) {
          item.setData(data[i]);
        } else {
          addItem(new WeatherMenuItem(i, data[i]));
        }
      }
    } else {
      ForecastOWM.saveForecast(null);
      var message = null;
      if (data instanceof Lang.Dictionary) {
        message = data["message"];
      }
      var update_error = {
        :code => code,
        :data => message,
      };
      WatchUi.pushView(
        new UpdateErrorView(update_error),
        null,
        WatchUi.SLIDE_IMMEDIATE
      );

      while (getItem(0) != null) {
        deleteItem(0);
      }
    }
    WatchUi.requestUpdate();
  }
}

class WeatherMenuItem extends WatchUi.CustomMenuItem {
  private var data;

  function initialize(index, data) {
    self.data = data;
    CustomMenuItem.initialize(index, {
      :drawable => createEmptyDrawable(index),
    });
  }

  function setData(data) {
    self.data = data;
  }

  function draw(dc) {
    var color = Graphics.COLOR_WHITE;
    dc.setColor(color, Graphics.COLOR_BLACK);
    dc.clear();
    dc.drawLine(0, 0, dc.getWidth(), 0);
    dc.drawLine(0, dc.getHeight() - 1, dc.getWidth(), dc.getHeight() - 1);

    //*************************************************************************
    //Date condition
    dc.setColor(color, Graphics.COLOR_TRANSPARENT);
    var font = Graphics.getVectorFont({
      :face => Global.vectorFontName(),
      :size => Math.floor(
        System.getDeviceSettings().screenHeight * 0.09
      ).toNumber(),
    });
    var font_h = Graphics.getFontHeight(font);

    var moment = new Time.Moment(data[Global.KEY_DT]);
    var info = Time.Gregorian.info(moment, Time.FORMAT_LONG);
    dc.drawText(
      2,
      0,
      font,
      Lang.format("$3$, $1$:$2$  $4$", [
        info.hour.format("%02d"),
        info.min.format("%02d"),
        info.day_of_week,
        data[Global.KEY_DESCRIPTION],
      ]),
      Graphics.TEXT_JUSTIFY_LEFT
    );

    //*************************************************************************
    //image
    var temp_y = font_h;
    var temp_x = 3;
    var rez = CommonOWM.findOWMResByCode(
      data[Global.KEY_ID],
      data[Global.KEY_ICON]
    );
    var bitmap = Application.loadResource(rez);
    dc.drawBitmap(temp_x, temp_y, bitmap);
    temp_x += bitmap.getWidth();

    //*************************************************************************
    //temperature
    var font_temp = Graphics.getVectorFont({
      :face => Global.vectorFontName(),
      :size => bitmap.getHeight(),
    });
    var font_temp_h = Graphics.getFontHeight(font_temp);
    var max_l_temp = dc.getTextWidthInPixels("-40°C", font_temp);

    dc.setColor(
      Global.getTempColor(data[Global.KEY_TEMP], color),
      Graphics.COLOR_TRANSPARENT
    );
    var str =
      Global.convertTemperature(data[Global.KEY_TEMP]) + Global.postfixTemp();
    dc.drawText(
      temp_x + max_l_temp / 2,
      temp_y,
      font_temp,
      str,
      Graphics.TEXT_JUSTIFY_CENTER
    );
    dc.setColor(color, Graphics.COLOR_TRANSPARENT);
    temp_x += max_l_temp;

    //*************************************************************************
    //Wind
    var wind_color = Global.getWindColor(data[Global.KEY_WIND_SPEED], color);
    var wind_bitmap = Global.getWindArrowImage(font_temp_h * 0.9, wind_color);
    var wind_angle = data[Global.KEY_WIND_DEG];
    var transform = new Graphics.AffineTransform();
    transform.rotate((2 * Math.PI * (wind_angle + 180)) / 360f);
    transform.translate(
      -wind_bitmap.getWidth() / 2f,
      -wind_bitmap.getHeight() / 2f
    );

    var arrow_x = temp_x + font_temp_h * 0.6;
    var arrow_y = temp_y + font_temp_h / 2;
    dc.drawBitmap2(arrow_x, arrow_y, wind_bitmap, {
      :transform => transform,
      :filterMode => Graphics.FILTER_MODE_BILINEAR,
    });

    temp_x += font_temp_h * 1.5;
    //*************************************************************************
    //Wind speed
    dc.setColor(color, Graphics.COLOR_TRANSPARENT);
    dc.drawText(
      temp_x,
      temp_y + (dc.getHeight() - temp_y) / 2,
      font,
      Global.converValueWindSpeed(data[Global.KEY_WIND_SPEED]),
      Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
    );
  }

  function createEmptyDrawable(id) {
    return new Toybox.WatchUi.Drawable({
      :identifier => id,
      :locX => 0,
      :locY => 0,
      :width => 0,
      :height => 0,
    });
  }
}

class TitleDrawable extends WatchUi.Drawable {
  function initialize(height) {
    Drawable.initialize({
      :identifier => 0,
      :locX => 0,
      :locY => 0,
      :width => System.getDeviceSettings().screenWidth,
      :height => height,
    });
  }

  function draw(dc) {
    var color = Graphics.COLOR_WHITE;
    dc.setColor(color, Graphics.COLOR_BLACK);
    dc.clear();
    var font = Graphics.getVectorFont({
      :face => Global.vectorFontName(),
      :size => Math.floor(dc.getHeight() / 2).toNumber(),
    });

    dc.drawText(
      dc.getWidth() / 2,
      dc.getHeight() / 2,
      font,
      Application.loadResource(Rez.Strings.Forecast),
      Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
    );
  }
}

class WeatherMenuDelegate extends WatchUi.Menu2InputDelegate {
  function onSelect(item) {
    var factory = new RoseOfWindLoopFactory();
    var loop = new Toybox.WatchUi.ViewLoop(factory, {
      :page => item.getId(),
      :wrap => true,
      :color => Graphics.COLOR_PURPLE,
    });
    WatchUi.pushView(
      loop,
      new RoseOfWindLoopDelegate(loop),
      WatchUi.SLIDE_IMMEDIATE
    );
  }
}
