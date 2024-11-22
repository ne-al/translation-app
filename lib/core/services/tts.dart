import 'package:flutter_tts/flutter_tts.dart';
import 'package:improve/core/utils/common.dart';

Future<void> speakWord(String word, String targetedLang) async {
  FlutterTts flutterTts = FlutterTts();
  String ttsLang;

  Map lang = Common().lang();

  await flutterTts.setSpeechRate(0.5);

  switch (lang[targetedLang]) {
    case "hi":
      ttsLang = "hi-IN";
      break;
    case "en":
      ttsLang = "en-IN";
      break;
    case "kn":
      ttsLang = "kn-IN";
      break;
    case "as":
      ttsLang = "as-IN";
      break;
    case "bn":
      ttsLang = "bn-IN";
      break;
    case "ta":
      ttsLang = "ta-IN";
      break;
    case "mr":
      ttsLang = "mr-IN";
      break;
    case "ml":
      ttsLang = "ml-IN";
      break;
    case "sa":
      ttsLang = "sa-IN";
      break;
    case "gu":
      ttsLang = "gu-IN";
      break;
    case "pa":
      ttsLang = "pa-IN";
      break;
    case "or":
      ttsLang = "or-IN";
      break;
    case "ne":
      ttsLang = "ne-NP";
      break;
    case "ja":
      ttsLang = "ja-JP";
      break;
    default:
      ttsLang = "hi-IN";
  }

  await flutterTts.setLanguage(ttsLang);

  await flutterTts.speak(word);
}
