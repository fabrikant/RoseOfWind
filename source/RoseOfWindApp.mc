import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

(:glance)
class RoseOfWindApp extends Application.AppBase {
  function initialize() {
    AppBase.initialize();
  }

  function onStart(state) {
    ForecastOWM.startRequest(self.method(:onWeatherUpdate));
  }

  function onStop(state) {}

  function getInitialView() {
    var loop = new RoseOfWindLoop();
    return [loop, new RoseOfWindLoopDelegate(loop)];
  }

  function getGlanceView() {
    return [new RoseOfWindGlance()];
  }

  function onWeatherUpdate(code, data) {
    if (code == 200) {
      ForecastOWM.saveForecast(data);
      WatchUi.requestUpdate();
    }
  }
}

function getApp() {
  return Application.getApp() as RoseOfWindApp;
}
