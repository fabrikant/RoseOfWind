using Toybox.Communications;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;

(:glance)
module ForecastOWM {
  function startRequest(callback) {
    var url = "https://api.openweathermap.org/data/2.5/forecast";
    var parametres = {
      "lat" => Application.Properties.getValue("Lat"),
      "lon" => Application.Properties.getValue("Lon"),
      "appid" => Application.Properties.getValue("keyOW"),
      "units" => "metric",
      "lang" => CommonOWM.getLang(),
    };
    var req = new RequestDelegate(
      new Lang.Method(CurrentOWM, :onResponse),
      callback
    );
    req.makeWebRequest(url, parametres, {});
  }

  function onResponse(code, data, context) {
    context.invoke(code, data);
  }

  function saveForecast(data) {
    var res = [];
    for (var i = 0; i < data["list"].size(); i++) {
      res.add({
        Global.KEY_ID => data["list"][i]["weather"][0]["id"],
        Global.KEY_ICON => data["list"][i]["weather"][0]["icon"],
        Global.KEY_DESCRIPTION => data["list"][i]["weather"][0]["description"],
        Global.KEY_MAIN => data["list"][i]["weather"][0]["main"],
        Global.KEY_TEMP => data["list"][i]["main"]["temp"],
        Global.KEY_TEMP_FEELS_LIKE => data["list"][i]["main"]["feels_like"],
        Global.KEY_TEMP_MIN => data["list"][i]["main"]["temp_min"],
        Global.KEY_TEMP_MAX => data["list"][i]["main"]["temp_max"],
        Global.KEY_PRESSURE => data["list"][i]["main"]["pressure"],
        Global.KEY_HUMIDITY => data["list"][i]["main"]["humidity"],
        Global.KEY_WIND_DEG => data["list"][i]["wind"]["deg"],
        Global.KEY_WIND_SPEED => data["list"][i]["wind"]["speed"],
        Global.KEY_DT => data["list"][i]["dt"],
        Global.KEY_CITY => data["city"]["name"],
      });
    }
    Application.Storage.setValue(Global.KEY_FORECAST, res);
  }
}
