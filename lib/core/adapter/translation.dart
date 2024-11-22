import 'package:hive/hive.dart';

part 'translation.g.dart';

@HiveType(typeId: 1)
class Translation {
  @HiveField(0)
  final String sourceLanguage;

  @HiveField(1)
  final String targetLanguage;

  @HiveField(2)
  final String text;

  Translation({
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.text,
  });
}
