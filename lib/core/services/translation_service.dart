import 'package:free_dictionary_api_v2/free_dictionary_api_v2.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:translator/translator.dart';

class TranslationService {
  final translator = GoogleTranslator();
  Box libraryBox = Hive.box('LIBRARY');
  Logger logger = Logger();

  // translate text
  Future<Map> translate(
    String word, {
    String translationFromLanguage = 'auto',
    String translationToLanguage = 'hi',
  }) async {
    List<FreeDictionaryResponse> meanings = [];
    Translation response = await translator.translate(
      word,
      from: translationFromLanguage,
      to: translationToLanguage,
    );

    if (translationToLanguage == "en") {
      meanings = await getWordMeaning(word);
    }

    saveTranslation(response);
    return {
      "translation": response,
      "meanings": meanings,
    };
  }

  // get word meaning if is in english
  Future<List<FreeDictionaryResponse>> getWordMeaning(String word) async {
    var meanings = await FreeDictionaryApiV2().getDefinition(word);

    logger.e(meanings);

    return meanings;
  }

  // save translated text to library
  Future<void> saveTranslation(Translation translation) async {
    String text = translation.text;
    String sourceLanguage = translation.sourceLanguage.name.toString();
    String targetLanguage = translation.targetLanguage.name.toString();

    // Check if the translation already exists
    final existingTranslation = libraryBox.values.firstWhere(
      (element) =>
          element['source_text'] == translation.source.toString() &&
          element['text'] == text &&
          element['from_language'] == sourceLanguage &&
          element['to_language'] == targetLanguage,
      orElse: () => null, // Return null if no match is found
    );

    if (existingTranslation != null) {
      // Find the index of the existing translation
      int index = libraryBox.values.toList().indexOf(existingTranslation);

      // Create a copy of the existing data
      Map<String, dynamic> updatedTranslation =
          Map<String, dynamic>.from(existingTranslation);

      // Increment the times_searched field
      updatedTranslation["times_searched"] =
          (updatedTranslation["times_searched"] ?? 0) + 1;

      // Write the updated translation back to the box
      await libraryBox.putAt(index, updatedTranslation);
    } else {
      // If it doesn't exist, add it to the box with initial times_searched as 1
      await libraryBox.add({
        "from_language": sourceLanguage,
        "to_language": targetLanguage,
        "source_text": translation.source.toString(),
        "text": text,
        "time": DateTime.now().millisecondsSinceEpoch,
        "appeared_in_test": 0,
        "last_appeared_in_test": null,
        "failed_guess": [],
        "last_failed_to_guess": null,
        "success_guesses": [],
        "last_success_to_guess": null,
        "times_searched": 1,
      });
    }
  }

  // delete a specific translation
  Future<void> deleteTranslation(
      String text, String sourceLanguage, String targetLanguage) async {
    // Find the matching translation
    final existingTranslation = libraryBox.values.firstWhere(
      (element) =>
          element['text'] == text &&
          element['from_language'] == sourceLanguage &&
          element['to_language'] == targetLanguage,
      orElse: () => null, // Return null if no match is found
    );

    if (existingTranslation != null) {
      // Get the index of the translation in the box
      int index = libraryBox.values.toList().indexOf(existingTranslation);

      // Delete the entry at the found index
      await libraryBox.deleteAt(index);
    }
  }

  // delete everything
  Future<void> clearAllTranslations() async {
    await libraryBox.clear();
  }
}




/**
 [mai-IN, hr-HR, ko-KR, mr-IN, as-IN, ru-RU, zh-TW, hu-HU, sw-KE, sd-IN, ks-IN, th-TH, doi-IN, ur-PK, nb-NO, da-DK, tr-TR, et-EE, pt-PT, vi-VN, en-US, sat-IN, sq-AL, sv-SE, ar, sr-RS, su-ID, bn-BD, bs-BA, mni-IN, gu-IN, kn-IN, el-GR, hi-IN, he-IL, fi-FI, bn-IN, km-KH, fr-FR, uk-UA, pa-IN, en-AU, nl-NL, fr-CA, lv-LV, pt-BR, de-DE, ml-IN, si-LK, cs-CZ, is-IS, pl-PL, ca-ES, sk-SK, it-IT, fil-PH, lt-LT, ne-NP, ms-MY, en-NG, nl-BE, zh-CN, es-ES, ja-JP, ta-IN, bg-BG, cy-GB, or-IN, brx-IN, sa-IN, yue-HK, es-US, en-IN, kok-IN, jv-ID, sl-SI, id-ID, te-IN, ro-RO, en-GB]
 */