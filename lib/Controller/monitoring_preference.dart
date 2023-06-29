import 'package:fukuro_mobile/Controller/SecureStorage.dart';

class CPULocalConfig {
  final Map<String, dynamic> _values = {};
  SecureStorage storage = SecureStorage();

  CPULocalConfig() ;
  save(Map<String, dynamic> val) async {
    if (val.containsKey('RTPeriod')) {
      _values["RTPeriod"] = val["RTPeriod"];
      await storage.write("RTPeriod", val["RTPeriod"]);
    }
    if (val.containsKey('HTPeriod')) {
      _values["HTPeriod"] = val["HTPeriod"];
      await storage.write("HTPeriod", val["HTPeriod"]);
    }
    if (val.containsKey('HTInterval')) {
      _values["HTInterval"] = val["HTInterval"];
      await storage.write("HTInterval", val["HTInterval"]);
    }
    if (val.containsKey('HTThreshold')) {
      _values["HTThreshold"] = val["HTThreshold"];
      await storage.write("HTThreshold", val["HTThreshold"]);
    }
    if (val.containsKey('HTExtractInterval')) {
      _values["HTExtractInterval"] = val["HTExtractInterval"];
   //   storage.write("HTExtractInterval", val["HTExtractInterval"]); //////
    }
  }

  load() async {
    values["RTPeriod"] = await storage.read("RTPeriod") ?? 60;
    values["HTPeriod"] = await storage.read("HTPeriod") ?? 3600;
    values["HTInterval"] = await storage.read("HTInterval") ?? 15;
    values["HTThreshold"] = await storage.read("HTThreshold") ?? 80;
    values["HTExtractInterval"] = await storage.read("HTExtractInterval") ?? 10; /////
  }
 

  dynamic get values {
    return _values;
  }
}
