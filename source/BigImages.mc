
module BigImages{

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
      "200d" => Rez.Drawables.BigCode200d,
      "200n" => Rez.Drawables.BigCode200n,
      "201d" => Rez.Drawables.BigCode201d,
      "201n" => Rez.Drawables.BigCode201n,
      "202d" => Rez.Drawables.BigCode202d,
      "202n" => Rez.Drawables.BigCode202n,
      "210d" => Rez.Drawables.BigCode210d,
      "210n" => Rez.Drawables.BigCode210n,
      "211d" => Rez.Drawables.BigCode211d,
      "211n" => Rez.Drawables.BigCode211n,
      "212d" => Rez.Drawables.BigCode212d,
      "212n" => Rez.Drawables.BigCode212n,
      "221d" => Rez.Drawables.BigCode221d,
      "221n" => Rez.Drawables.BigCode221n,
      "230d" => Rez.Drawables.BigCode230d,
      "230n" => Rez.Drawables.BigCode230n,
      "231d" => Rez.Drawables.BigCode231d,
      "231n" => Rez.Drawables.BigCode231n,
      "232d" => Rez.Drawables.BigCode232d,
      "232n" => Rez.Drawables.BigCode232n,
    };
  }

  function codes300() {
    //Drizzle
    return {
      "300d" => Rez.Drawables.BigCode300d,
      "300n" => Rez.Drawables.BigCode300n,
      "301d" => Rez.Drawables.BigCode301d,
      "301n" => Rez.Drawables.BigCode301n,
      "302d" => Rez.Drawables.BigCode302d,
      "302n" => Rez.Drawables.BigCode302n,
      "310d" => Rez.Drawables.BigCode310d,
      "310n" => Rez.Drawables.BigCode310n,
      "311d" => Rez.Drawables.BigCode311d,
      "311n" => Rez.Drawables.BigCode311n,
      "312d" => Rez.Drawables.BigCode312d,
      "312n" => Rez.Drawables.BigCode312n,
      "313d" => Rez.Drawables.BigCode313d,
      "313n" => Rez.Drawables.BigCode313n,
      "314d" => Rez.Drawables.BigCode314d,
      "314n" => Rez.Drawables.BigCode314n,
      "321d" => Rez.Drawables.BigCode321d,
      "321n" => Rez.Drawables.BigCode321n,
    };
  }

  function codes500() {
    //Rain
    return {
      "500d" => Rez.Drawables.BigCode500d,
      "500n" => Rez.Drawables.BigCode500n,
      "501d" => Rez.Drawables.BigCode501d,
      "501n" => Rez.Drawables.BigCode501n,
      "502d" => Rez.Drawables.BigCode502d,
      "502n" => Rez.Drawables.BigCode502n,
      "503d" => Rez.Drawables.BigCode503d,
      "503n" => Rez.Drawables.BigCode503n,
      "504d" => Rez.Drawables.BigCode504d,
      "504n" => Rez.Drawables.BigCode504n,
      "511d" => Rez.Drawables.BigCode511d,
      "511n" => Rez.Drawables.BigCode511n,
      "520d" => Rez.Drawables.BigCode520d,
      "520n" => Rez.Drawables.BigCode520n,
      "521d" => Rez.Drawables.BigCode521d,
      "521n" => Rez.Drawables.BigCode521n,
      "522d" => Rez.Drawables.BigCode522d,
      "522n" => Rez.Drawables.BigCode522n,
      "531d" => Rez.Drawables.BigCode531d,
      "531n" => Rez.Drawables.BigCode531n,
    };
  }

  function codes600() {
    //Snow
    return {
      "600d" => Rez.Drawables.BigCode600d,
      "600n" => Rez.Drawables.BigCode600n,
      "601d" => Rez.Drawables.BigCode601d,
      "601n" => Rez.Drawables.BigCode601n,
      "602d" => Rez.Drawables.BigCode602d,
      "602n" => Rez.Drawables.BigCode602n,
      "611d" => Rez.Drawables.BigCode611d,
      "611n" => Rez.Drawables.BigCode611n,
      "612d" => Rez.Drawables.BigCode612d,
      "612n" => Rez.Drawables.BigCode612n,
      "613d" => Rez.Drawables.BigCode613d,
      "613n" => Rez.Drawables.BigCode613n,
      "615d" => Rez.Drawables.BigCode615d,
      "615n" => Rez.Drawables.BigCode615n,
      "616d" => Rez.Drawables.BigCode616d,
      "616n" => Rez.Drawables.BigCode616n,
      "620d" => Rez.Drawables.BigCode620d,
      "620n" => Rez.Drawables.BigCode620n,
      "621d" => Rez.Drawables.BigCode621d,
      "621n" => Rez.Drawables.BigCode621n,
      "622d" => Rez.Drawables.BigCode622d,
      "622n" => Rez.Drawables.BigCode622n,
    };
  }

  function codes700() {
    //Atmosphere
    return {
      "701d" => Rez.Drawables.BigCode701d,
      "701n" => Rez.Drawables.BigCode701n,
      "711d" => Rez.Drawables.BigCode711d,
      "711n" => Rez.Drawables.BigCode711n,
      "721d" => Rez.Drawables.BigCode721d,
      "721n" => Rez.Drawables.BigCode721n,
      "731d" => Rez.Drawables.BigCode731d,
      "731n" => Rez.Drawables.BigCode731n,
      "741d" => Rez.Drawables.BigCode741d,
      "741n" => Rez.Drawables.BigCode741n,
      "751d" => Rez.Drawables.BigCode751d,
      "751n" => Rez.Drawables.BigCode751n,
      "761d" => Rez.Drawables.BigCode761d,
      "761n" => Rez.Drawables.BigCode761n,
      "762d" => Rez.Drawables.BigCode762d,
      "762n" => Rez.Drawables.BigCode762n,
      "771d" => Rez.Drawables.BigCode771d,
      "771n" => Rez.Drawables.BigCode771n,
      "781d" => Rez.Drawables.BigCode781d,
      "781n" => Rez.Drawables.BigCode781n,
    };
  }

  function codes800() {
    //Cloud
    return {
      "800d" => Rez.Drawables.BigCode800d,
      "800n" => Rez.Drawables.BigCode800n,
      "801d" => Rez.Drawables.BigCode801d,
      "801n" => Rez.Drawables.BigCode801n,
      "802d" => Rez.Drawables.BigCode802d,
      "802n" => Rez.Drawables.BigCode802n,
      "803d" => Rez.Drawables.BigCode803d,
      "803n" => Rez.Drawables.BigCode803n,
      "804d" => Rez.Drawables.BigCode804d,
      "804n" => Rez.Drawables.BigCode804n,
    };
  }
}