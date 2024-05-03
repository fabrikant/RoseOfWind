import Toybox.WatchUi;

class RoseOfWindLoopDelegate extends WatchUi.ViewLoopDelegate {
  private var view_loop;

  function initialize(view_loop) {
    ViewLoopDelegate.initialize(view_loop);
    self.view_loop = view_loop;
  }

  function onNextView() {
    view_loop.changeView(WatchUi.ViewLoop.DIRECTION_NEXT);
    return true;
  }

  function onPreviousView() {
    view_loop.changeView(WatchUi.ViewLoop.DIRECTION_PREVIOUS);
    return true;
  }
}

class RoseOfWindLoopFactory extends WatchUi.ViewLoopFactory {
  private var data;

  function initialize() {
    data = Application.Storage.getValue(Global.KEY_FORECAST);
    ViewLoopFactory.initialize();
  }

  function onWeatherUpdate(){
    data = Application.Storage.getValue(Global.KEY_FORECAST);
  }

  function getView(page) {
    var page_data = null;
    if (data instanceof Lang.Array){
      page_data = data[page];
    }
    return [new RoseOfWindView(page_data), new RoseOfWindViewDelegate(page)];
  }

  function getSize() {
    if (data == null) {
      return 1;
    } else {
      return data.size();
    }
  }
}
