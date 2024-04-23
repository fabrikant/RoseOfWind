import Toybox.System;
import Toybox.Application;
import Toybox.Math;
import Toybox.Graphics;
import Toybox.Lang;

(:glance)
module Global {
  enum {
    KEY_CURRENT,
    KEY_FORECAST,
    KEY_ID,
    KEY_ICON,
    KEY_DESCRIPTION,
    KEY_MAIN,
    KEY_TEMP,
    KEY_TEMP_FEELS_LIKE,
    KEY_TEMP_MIN,
    KEY_TEMP_MAX,
    KEY_PRESSURE,
    KEY_HUMIDITY,
    KEY_WIND_DEG,
    KEY_WIND_SPEED,
    KEY_DT,
    KEY_CITY,

    UNIT_SPEED_MS = 0,
    UNIT_SPEED_KMH,
    UNIT_SPEED_MLH,
    UNIT_SPEED_FTS,
    UNIT_SPEED_BEAUF,
    UNIT_SPEED_KNOTS,

    UNIT_PRESSURE_MM_HG = 0,
    UNIT_PRESSURE_PSI,
    UNIT_PRESSURE_INCH_HG,
    UNIT_PRESSURE_BAR,
    UNIT_PRESSURE_KPA,
  }

  function vectorFontName() {
    return ["RobotoCondensedRegular", "RobotoRegular"];
  }

  function getWindArrowImage(size, color) {
    var coords = [
      [0, size / 2],
      [size / 4, size / 2],
      [size / 4, size],
      [size / 2, size],
      [size / 2, size / 2],
      [(size * 3) / 4, size / 2],
      [(size * 3) / 8, 0],
    ];

    var buf_bitmap_ref = Graphics.createBufferedBitmap({
      :width => (size * 3) / 4,
      :height => size,
    });
    var dc = buf_bitmap_ref.get().getDc();
    dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
    dc.clear();
    dc.setColor(color, color);
    dc.fillPolygon(coords);

    return buf_bitmap_ref;
  }

  function convertPressure(value) {
    var rawData = value*100;
    var unit_str = "";
    var unit = Application.Properties.getValue("PressureUnit");
    if (unit == UNIT_PRESSURE_MM_HG) {
      /*MmHg*/
      value = Math.round(rawData / 133.322).format("%d");
      unit_str = Application.loadResource(Rez.Strings.PrUMmHg);
    } else if (unit == UNIT_PRESSURE_PSI) {
      /*Psi*/
      value = (rawData.toFloat() / 6894.757).format("%.2f");
      unit_str = Application.loadResource(Rez.Strings.PrUPsi);
    } else if (unit == UNIT_PRESSURE_INCH_HG) {
      /*InchHg*/
      value = (rawData.toFloat() / 3386.389).format("%.2f");
      unit_str = Application.loadResource(Rez.Strings.PrUInchHg);
    } else if (unit == UNIT_PRESSURE_BAR) {
      /*miliBar*/
      value = (rawData / 100).format("%d");
      unit_str = Application.loadResource(Rez.Strings.PrUBar);
    } else if (unit == UNIT_PRESSURE_KPA) {
      /*kPa*/
      value = (rawData / 1000).format("%d");
      unit_str = Application.loadResource(Rez.Strings.PrUKPa);
    }
    return Lang.format("$1$$2$",[value,unit_str]);
  }

  function convertTemperature(сelsius) {
    var value;
    if (сelsius != null) {
      if (System.getDeviceSettings().temperatureUnits == System.UNIT_STATUTE) {
        /*F*/
        value = (сelsius * 9) / 5 + 32;
      } else {
        value = сelsius;
      }
    } else {
      value = "";
    }
    return value.format("%d") + "°";
  }

  function converValueWindSpeed(wind_speed) {
    var value = wind_speed; //meters/sec
    if (value == null) {
      return "";
    }
    var unit_str = "";
    var unit = Application.Properties.getValue("WindSpeedUnit");
    if (unit == Global.UNIT_SPEED_MS) {
      unit_str = Application.loadResource(Rez.Strings.SpeedUnitMSec);
    } else if (unit == Global.UNIT_SPEED_KMH) {
      /*km/h*/
      value = wind_speed * 3.6;
      unit_str = Application.loadResource(Rez.Strings.SpeedUnitKmH);
    } else if (unit == Global.UNIT_SPEED_MLH) {
      /*mile/h*/
      value = wind_speed * 2.237;
      unit_str = Application.loadResource(Rez.Strings.SpeedUnitMileH);
    } else if (unit == Global.UNIT_SPEED_FTS) {
      /*ft/s*/
      value = wind_speed * 3.281;
      unit_str = Application.loadResource(Rez.Strings.SpeedUnitFtSec);
    } else if (unit == Global.UNIT_SPEED_BEAUF) {
      /*Beaufort*/
      value = getBeaufort(wind_speed);
      unit_str = Application.loadResource(Rez.Strings.SpeedUnitBeauf);
    } else if (unit == Global.UNIT_SPEED_KNOTS) {
      /*knots*/
      value = wind_speed * 1.94384;
      unit_str = Application.loadResource(Rez.Strings.SpeedUnitKnots);
    }
    var res = "";
    try {
      res = value.format("%d") + " " + unit_str;
    } catch (ex) {}
    return res;
  }

  function getBeaufort(wind_speed) {
    if (wind_speed >= 33) {
      return 12;
    } else if (wind_speed >= 28.5) {
      return 11;
    } else if (wind_speed >= 24.5) {
      return 10;
    } else if (wind_speed >= 20.8) {
      return 9;
    } else if (wind_speed >= 17.2) {
      return 8;
    } else if (wind_speed >= 13.9) {
      return 7;
    } else if (wind_speed >= 10.8) {
      return 6;
    } else if (wind_speed >= 8) {
      return 5;
    } else if (wind_speed >= 5.5) {
      return 4;
    } else if (wind_speed >= 3.4) {
      return 3;
    } else if (wind_speed >= 1.6) {
      return 2;
    } else if (wind_speed >= 0.3) {
      return 1;
    } else {
      return 0;
    }
  }

  ///////////////////////////////////////////////////////////////////////////
  function getWindColor(windSpeed, default_color) {
    var color = default_color;

    var bf = getBeaufort(windSpeed);
    if (bf > 9) {
      color = 0xff0000;
    } else if (bf > 8) {
      color = 0xff00aa;
    } else if (bf > 7) {
      color = 0xffaaff;
    } else if (bf > 6) {
      color = 0x00ffff;
    } else if (bf > 5) {
      color = 0xaaffff;
    } else if (bf > 4) {
      color = Graphics.COLOR_YELLOW;
    } else if (bf > 3) {
      color = 0x00ff00;
    } else if (bf > 2) {
      color = 0x55ff55;
    } else {
      color = Graphics.COLOR_WHITE;
    }
    return color;
  }

  function getTempColor(temp, default_color) {
    var color = default_color;
    if (temp > 30) {
      color = 0xff0000;
    } else if (temp > 25) {
      color = 0xff0055;
    } else if (temp > 20) {
      color = 0x00ff00;
    } else if (temp > 15) {
      color = 0x00ff55;
    } else if (temp > 10) {
      color = 0x55ff00;
    } else if (temp > 5) {
      color = 0xffff00;
    } else if (temp > 0) {
      color = 0xffffaa;
    } else if (temp > -10) {
      color = 0xaaffff;
    } else if (temp > -20) {
      color = 0x55ffff;
    } else {
      color = 0x00ffff;
    }
    return color;
  }
}
