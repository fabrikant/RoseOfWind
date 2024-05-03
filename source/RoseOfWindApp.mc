import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Activity;
import Toybox.Weather;

(:glance)
class RoseOfWindApp extends Application.AppBase {
  var menu_weak;

  function initialize() {
    menu_weak = null;
    AppBase.initialize();
  }

  function onStart(state) {
    captureLocation();
    updateComplications();
  }

  function onStop(state) {}

  function updateComplications() {
    try {
      Complications.updateComplication(0, {
        :value => Application.Properties.getValue("keyOW"),
      });
    } catch (ex) {}
  }

  function getInitialView() {
    var owm_key = Application.Properties.getValue("keyOW");
    if (owm_key.equals("")) {
      return [new NoKeyView(), new NoKeyDelegate()];
    } else {
      if (Application.Properties.getValue("ShowCurrentCondition")) {
        var data = Application.Storage.getValue(Global.KEY_CURRENT);
        return [new RoseOfWindCurrentView(data), new RoseOfWindCurrentViewDelegate()];
      } else {
        return getForecastViewArray();
      }
    }
  }

  function getForecastViewArray() {
    var menu = new WeatherMenu();
    menu_weak = menu.weak();
    return [menu, new WeatherMenuDelegate()];
  }

  function getGlanceView() {
    return [new RoseOfWindGlance()];
  }

  function captureLocation() {
    var location = Activity.getActivityInfo().currentLocation;
    var loc_degrees = [0f, 0f];
    if (location != null) {
      loc_degrees = location.toDegrees();
    }
    if (loc_degrees[0] != 0f || loc_degrees[1] != 0f) {
      Application.Properties.setValue("Lat", loc_degrees[0]);
      Application.Properties.setValue("Lon", loc_degrees[1]);
    } else {
      var weather = Toybox.Weather.getCurrentConditions();
      if (weather != null) {
        location = weather.observationLocationPosition;
        if (location != null) {
          loc_degrees = location.toDegrees();
        }
        if (loc_degrees[0] != 0f || loc_degrees[1] != 0f) {
          Application.Properties.setValue("Lat", loc_degrees[0]);
          Application.Properties.setValue("Lon", loc_degrees[1]);
        }
      }
    }
  }
}

function getApp() {
  return Application.getApp() as RoseOfWindApp;
}
