import 'package:improve/core/data/languages.dart';

class Common {
  Map lang() {
    Map language = {};
    for (var e in allLanguages) {
      language.addAll({e['name']: e['code']});
    }

    return language;
  }
}
