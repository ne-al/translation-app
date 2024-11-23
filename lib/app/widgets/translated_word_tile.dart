import 'package:flutter/material.dart';
import 'package:improve/app/widgets/word_tile.dart';
import 'package:translator/translator.dart';

class TranslatedWordTile extends StatelessWidget {
  final Translation translation;
  const TranslatedWordTile({
    super.key,
    required this.translation,
  });

  @override
  Widget build(BuildContext context) {
    Map value = {
      "source_text": translation.source.toString(),
      "text": translation.text,
      "from_language": translation.sourceLanguage.name,
      "to_language": translation.targetLanguage.name,
    };
    return WordTile(value: value);
  }
}
