import Toybox.WatchUi;
import Toybox.Application;

class TextDelegate extends WatchUi.TextPickerDelegate {
  var prop_name;

  function initialize(prop_name) {
    self.prop_name = prop_name;
    TextPickerDelegate.initialize();
  }

  function onTextEntered(text, changed) {
    if (changed ) {
      Application.Properties.setValue(prop_name, text);
      getApp().startRequest();
    }
  }

  function onCancel() {
  }
}
