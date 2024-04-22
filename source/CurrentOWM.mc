using Toybox.Communications;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;

(:glance)
module CurrentOWM {
  function startRequest(callback) {
    var url = "https://api.openweathermap.org/data/2.5/weather";
    var units = "metric";
    if (System.getDeviceSettings().temperatureUnits == System.UNIT_STATUTE) {
      units = "imperial";
    }
    var parametres = {
      "lat" => Application.Properties.getValue("Lat"),
      "lon" => Application.Properties.getValue("Lon"),
      "appid" => Application.Properties.getValue("keyOW"),
      "units" => units,
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
}
