using Toybox.Communications;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;

(:glance)
module CurrentOWM {
  function startRequest(callback) {
    var owm_key = Application.Properties.getValue("keyOW");
    if (owm_key.equals("")) {
      return;
    }
    var url = "https://api.openweathermap.org/data/2.5/weather";
    var parametres = {
      "lat" => Application.Properties.getValue("Lat"),
      "lon" => Application.Properties.getValue("Lon"),
      "appid" => owm_key,
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
}
