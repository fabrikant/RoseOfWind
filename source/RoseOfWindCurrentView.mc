import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Time;
import Toybox.Math;
import Toybox.System;

class RoseOfWindCurrentView extends RoseOfWindView {
  
  function initialize(data) {
    RoseOfWindView.initialize(data);
    CurrentOWM.startRequest(self.method(:onWeatherUpdate));
  }

  function onWeatherUpdate(code, data) {
    if (code == 200) {
      CommonOWM.saveCurrentCondition(data);
    } else {
      CommonOWM.saveCurrentCondition(null);
    }
    data = Application.Storage.getValue(Global.KEY_CURRENT);
    WatchUi.requestUpdate();
  }
}

class RoseOfWindCurrentViewDelegate extends WatchUi.BehaviorDelegate {
  public function initialize() {
    BehaviorDelegate.initialize();
  }

  public function onSelect() {
    var array = getApp().getForecastViewArray();
    WatchUi.pushView(array[0], array[1], WatchUi.SLIDE_IMMEDIATE);
    return true;
  }
}
