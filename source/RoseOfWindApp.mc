import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Activity;
import Toybox.Weather;

(:glance)
class RoseOfWindApp extends Application.AppBase {
  var loop_factory_weak;

  function initialize() {
    loop_factory_weak = null;
    AppBase.initialize();
    captureLocation();
    startRequest();
  }

  function startRequest() {
    ForecastOWM.startRequest(self.method(:onWeatherUpdate));
  }

  function onStart(state) {}

  function onStop(state) {}

  function getInitialView() {
    var owm_key = Application.Properties.getValue("keyOW");
    if (owm_key.equals("")) {
      return [new NoKeyView(), new NoKeyDelegate()];
    } else {

      return [new WeatherMenu(), new WeatherMenuDelegate()];
    }
  }

  function getGlanceView() {
    return [new RoseOfWindGlance()];
  }

  function onWeatherUpdate(code, data) {
    if (code == 200) {
      ForecastOWM.saveForecast(data);
      if (loop_factory_weak != null) {
        if (loop_factory_weak.stillAlive()) {
          var factory = loop_factory_weak.get();
          factory.onWeatherUpdate();
        }
      }
      WatchUi.requestUpdate();
    }
  }

  function captureLocation() {
    var location = Activity.getActivityInfo().currentLocation;
    if (location != null) {
      var degr = location.toDegrees();
      Application.Properties.setValue("Lat", degr[0]);
      Application.Properties.setValue("Lon", degr[1]);
    } else {
      var weather = Toybox.Weather.getCurrentConditions();
      if (weather != null) {
        location = weather.observationLocationPosition;
        if (location != null) {
          var degr = location.toDegrees();
          Application.Properties.setValue("Lat", degr[0]);
          Application.Properties.setValue("Lon", degr[1]);
        }
      }
    }
  }
}

function getApp() {
  return Application.getApp() as RoseOfWindApp;
}
