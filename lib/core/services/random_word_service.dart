import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:improve/core/services/translation_service.dart';
import 'package:logger/logger.dart';

class RandomWordService {
  final String baseUrl = "https://random-word-api.herokuapp.com";
  Future<Map?> getRandomWord(String language) async {
    // assigning variables
    Map data = {};

    Uri url = Uri.parse("$baseUrl/word");

    try {
      // getting response from the api
      final response = await http.get(url);

      // checking if the response is successful
      if (response.statusCode == 200) {
        // decoding the response
        var responseWord = jsonDecode(response.body);

        String word = responseWord[0];

        Logger().i(word);

        var translation = await TranslationService().translate(
          word,
          translationFromLanguage: "en",
          translationToLanguage: language == "en" ? "hi" : language,
          saveTranslationToLibrary: false,
        );

        // Translation translatedData = translation["translation"];

        data = {
          "word": word,
          "translatedText": translation["translation"].text,
          "from_language": translation["translation"].sourceLanguage.name,
          "to_language": translation["translation"].targetLanguage.name,
        };

        Logger().e(data);
        // finally returning the data
        return data;
      }
    } catch (e) {
      return {};
    }
    return null;
  }
}
