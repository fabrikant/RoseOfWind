import Toybox.Application;
import Toybox.System;
import Toybox.Time;
import Toybox.Weather;

(:glance)
module CommonOWM {
  function saveCurrentCondition(data) {
    if (data == null) {
      Application.Storage.deleteValue(Global.KEY_CURRENT);
    } else {
      var result = {
        Global.KEY_ID => data["weather"][0]["id"],
        Global.KEY_ICON => data["weather"][0]["icon"],
        Global.KEY_DESCRIPTION => data["weather"][0]["description"],
        Global.KEY_MAIN => data["weather"][0]["main"],
        Global.KEY_TEMP => data["main"]["temp"],
        Global.KEY_TEMP_FEELS_LIKE => data["main"]["feels_like"],
        Global.KEY_TEMP_MIN => data["main"]["temp_min"],
        Global.KEY_TEMP_MAX => data["main"]["temp_max"],
        Global.KEY_PRESSURE => data["main"]["pressure"],
        Global.KEY_HUMIDITY => data["main"]["humidity"],
        Global.KEY_WIND_DEG => data["wind"]["deg"],
        Global.KEY_WIND_SPEED => data["wind"]["speed"],
        Global.KEY_DT => data["dt"],
        Global.KEY_CITY => data["name"],
      };

      Application.Storage.setValue(Global.KEY_CURRENT, result);
    }
  }

  function getLang() {
    var res = "en";
    var sysLang = System.getDeviceSettings().systemLanguage;

    if (sysLang == System.LANGUAGE_ARA) {
      res = "ar";
    } else if (sysLang == System.LANGUAGE_BUL) {
      res = "bg";
    } else if (sysLang == System.LANGUAGE_CES) {
      res = "cz";
    } else if (sysLang == System.LANGUAGE_CHS) {
      res = "zh_cn";
    } else if (sysLang == System.LANGUAGE_CHT) {
      res = "zh_tw";
    } else if (sysLang == System.LANGUAGE_DAN) {
      res = "da";
    } else if (sysLang == System.LANGUAGE_DEU) {
      res = "de";
    } else if (sysLang == System.LANGUAGE_DUT) {
      res = "de";
    } else if (sysLang == System.LANGUAGE_FIN) {
      res = "fi";
    } else if (sysLang == System.LANGUAGE_FRE) {
      res = "fr";
    } else if (sysLang == System.LANGUAGE_GRE) {
      res = "el";
    } else if (sysLang == System.LANGUAGE_HEB) {
      res = "he";
    } else if (sysLang == System.LANGUAGE_HRV) {
      res = "hr";
    } else if (sysLang == System.LANGUAGE_HUN) {
      res = "hu";
    } else if (sysLang == System.LANGUAGE_IND) {
      res = "hi";
    } else if (sysLang == System.LANGUAGE_ITA) {
      res = "it";
    } else if (sysLang == System.LANGUAGE_JPN) {
      res = "ja";
    } else if (sysLang == System.LANGUAGE_KOR) {
      res = "	kr";
    } else if (sysLang == System.LANGUAGE_LAV) {
      res = "la";
    } else if (sysLang == System.LANGUAGE_LIT) {
      res = "lt";
    } else if (sysLang == System.LANGUAGE_NOB) {
      res = "no";
    } else if (sysLang == System.LANGUAGE_POL) {
      res = "pl";
    } else if (sysLang == System.LANGUAGE_POR) {
      res = "pt";
    } else if (sysLang == System.LANGUAGE_RON) {
      res = "ro";
    } else if (sysLang == System.LANGUAGE_RUS) {
      res = "ru";
    } else if (sysLang == System.LANGUAGE_SLO) {
      res = "sk";
    } else if (sysLang == System.LANGUAGE_SLV) {
      res = "	sl";
    } else if (sysLang == System.LANGUAGE_SPA) {
      res = "sp";
    } else if (sysLang == System.LANGUAGE_SWE) {
      res = "sv";
    } else if (sysLang == System.LANGUAGE_THA) {
      res = "th";
    } else if (sysLang == System.LANGUAGE_TUR) {
      res = "tr";
    } else if (sysLang == System.LANGUAGE_UKR) {
      res = "ua";
    } else if (sysLang == System.LANGUAGE_VIE) {
      res = "vi";
    } else if (sysLang == System.LANGUAGE_ZSM) {
      res = "zu";
    }
    return res;
  }

  function findOWMResByCode(id, icon) {
    var codes;
    if (id < 300) {
      codes = codes200();
    } else if (id < 500) {
      codes = codes300();
    } else if (id < 600) {
      codes = codes500();
    } else if (id < 700) {
      codes = codes600();
    } else if (id < 800) {
      codes = codes700();
    } else {
      codes = codes800();
    }

    var len = icon.length();
    var key = id.toString() + icon.substring(len - 1, len);

    var res = Rez.Drawables.NA;
    if (codes[key] != null) {
      res = codes[key];
    }
    return res;
  }

  function codes200() {
    //Thunderstorm
    return {
      "200d" => Rez.Drawables.Code200d,
      "200n" => Rez.Drawables.Code200n,
      "201d" => Rez.Drawables.Code201d,
      "201n" => Rez.Drawables.Code201n,
      "202d" => Rez.Drawables.Code202d,
      "202n" => Rez.Drawables.Code202n,
      "210d" => Rez.Drawables.Code210d,
      "210n" => Rez.Drawables.Code210n,
      "211d" => Rez.Drawables.Code211d,
      "211n" => Rez.Drawables.Code211n,
      "212d" => Rez.Drawables.Code212d,
      "212n" => Rez.Drawables.Code212n,
      "221d" => Rez.Drawables.Code221d,
      "221n" => Rez.Drawables.Code221n,
      "230d" => Rez.Drawables.Code230d,
      "230n" => Rez.Drawables.Code230n,
      "231d" => Rez.Drawables.Code231d,
      "231n" => Rez.Drawables.Code231n,
      "232d" => Rez.Drawables.Code232d,
      "232n" => Rez.Drawables.Code232n,
    };
  }

  function codes300() {
    //Drizzle
    return {
      "300d" => Rez.Drawables.Code300d,
      "300n" => Rez.Drawables.Code300n,
      "301d" => Rez.Drawables.Code301d,
      "301n" => Rez.Drawables.Code301n,
      "302d" => Rez.Drawables.Code302d,
      "302n" => Rez.Drawables.Code302n,
      "310d" => Rez.Drawables.Code310d,
      "310n" => Rez.Drawables.Code310n,
      "311d" => Rez.Drawables.Code311d,
      "311n" => Rez.Drawables.Code311n,
      "312d" => Rez.Drawables.Code312d,
      "312n" => Rez.Drawables.Code312n,
      "313d" => Rez.Drawables.Code313d,
      "313n" => Rez.Drawables.Code313n,
      "314d" => Rez.Drawables.Code314d,
      "314n" => Rez.Drawables.Code314n,
      "321d" => Rez.Drawables.Code321d,
      "321n" => Rez.Drawables.Code321n,
    };
  }

  function codes500() {
    //Rain
    return {
      "500d" => Rez.Drawables.Code500d,
      "500n" => Rez.Drawables.Code500n,
      "501d" => Rez.Drawables.Code501d,
      "501n" => Rez.Drawables.Code501n,
      "502d" => Rez.Drawables.Code502d,
      "502n" => Rez.Drawables.Code502n,
      "503d" => Rez.Drawables.Code503d,
      "503n" => Rez.Drawables.Code503n,
      "504d" => Rez.Drawables.Code504d,
      "504n" => Rez.Drawables.Code504n,
      "511d" => Rez.Drawables.Code511d,
      "511n" => Rez.Drawables.Code511n,
      "520d" => Rez.Drawables.Code520d,
      "520n" => Rez.Drawables.Code520n,
      "521d" => Rez.Drawables.Code521d,
      "521n" => Rez.Drawables.Code521n,
      "522d" => Rez.Drawables.Code522d,
      "522n" => Rez.Drawables.Code522n,
      "531d" => Rez.Drawables.Code531d,
      "531n" => Rez.Drawables.Code531n,
    };
  }

  function codes600() {
    //Snow
    return {
      "600d" => Rez.Drawables.Code600d,
      "600n" => Rez.Drawables.Code600n,
      "601d" => Rez.Drawables.Code601d,
      "601n" => Rez.Drawables.Code601n,
      "602d" => Rez.Drawables.Code602d,
      "602n" => Rez.Drawables.Code602n,
      "611d" => Rez.Drawables.Code611d,
      "611n" => Rez.Drawables.Code611n,
      "612d" => Rez.Drawables.Code612d,
      "612n" => Rez.Drawables.Code612n,
      "613d" => Rez.Drawables.Code613d,
      "613n" => Rez.Drawables.Code613n,
      "615d" => Rez.Drawables.Code615d,
      "615n" => Rez.Drawables.Code615n,
      "616d" => Rez.Drawables.Code616d,
      "616n" => Rez.Drawables.Code616n,
      "620d" => Rez.Drawables.Code620d,
      "620n" => Rez.Drawables.Code620n,
      "621d" => Rez.Drawables.Code621d,
      "621n" => Rez.Drawables.Code621n,
      "622d" => Rez.Drawables.Code622d,
      "622n" => Rez.Drawables.Code622n,
    };
  }

  function codes700() {
    //Atmosphere
    return {
      "701d" => Rez.Drawables.Code701d,
      "701n" => Rez.Drawables.Code701n,
      "711d" => Rez.Drawables.Code711d,
      "711n" => Rez.Drawables.Code711n,
      "721d" => Rez.Drawables.Code721d,
      "721n" => Rez.Drawables.Code721n,
      "731d" => Rez.Drawables.Code731d,
      "731n" => Rez.Drawables.Code731n,
      "741d" => Rez.Drawables.Code741d,
      "741n" => Rez.Drawables.Code741n,
      "751d" => Rez.Drawables.Code751d,
      "751n" => Rez.Drawables.Code751n,
      "761d" => Rez.Drawables.Code761d,
      "761n" => Rez.Drawables.Code761n,
      "762d" => Rez.Drawables.Code762d,
      "762n" => Rez.Drawables.Code762n,
      "771d" => Rez.Drawables.Code771d,
      "771n" => Rez.Drawables.Code771n,
      "781d" => Rez.Drawables.Code781d,
      "781n" => Rez.Drawables.Code781n,
    };
  }

  function codes800() {
    //Cloud
    return {
      "800d" => Rez.Drawables.Code800d,
      "800n" => Rez.Drawables.Code800n,
      "801d" => Rez.Drawables.Code801d,
      "801n" => Rez.Drawables.Code801n,
      "802d" => Rez.Drawables.Code802d,
      "802n" => Rez.Drawables.Code802n,
      "803d" => Rez.Drawables.Code803d,
      "803n" => Rez.Drawables.Code803n,
      "804d" => Rez.Drawables.Code804d,
      "804n" => Rez.Drawables.Code804n,
    };
  }
}
