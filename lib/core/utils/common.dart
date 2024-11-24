import 'package:improve/core/data/languages.dart';

class Common {
  Map langFromNameToCode() {
    Map language = {};
    for (var e in allLanguages) {
      language.addAll({e['name']: e['code']});
    }

    return language;
  }

  Map langFromCodeToName() {
    Map language = {};
    for (var e in allLanguages) {
      language.addAll({e['code']: e['name']});
    }

    return language;
  }
}
