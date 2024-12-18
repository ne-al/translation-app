import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:improve/core/services/random_word_service.dart';
import 'package:improve/core/services/translation_service.dart';
import 'package:improve/core/services/tts.dart';
import 'package:improve/core/utils/common.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/logger.dart';

class LearningPage extends StatefulWidget {
  final String learningLang;
  const LearningPage({
    super.key,
    required this.learningLang,
  });

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  Map? data = {};
  bool isLoading = false;
  bool isLiked = false;
  Box libraryBox = Hive.box("LIBRARY");
  int totalWords = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    var response = await RandomWordService().getRandomWord(widget.learningLang);

    setState(() {
      data = {
        "word": response?["word"],
        "from_language": response?["translation"].sourceLanguage.name,
        "to_language": response?["translation"].targetLanguage.name,
        "translation": response?["translation"],
        "translatedText": response?["translation"].text,
      };
      isLoading = false;
      isLiked = false;
      totalWords = ++totalWords;
      Logger().d(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceContainerLow,
                        child: Icon(
                          Icons.close,
                          color:
                              Theme.of(context).colorScheme.onTertiaryContainer,
                        ),
                      ),
                      const Gap(14),
                      Text(
                        "You've learned $totalWords words so far",
                        style: GoogleFonts.lato(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Gap(80),
                      Container(
                        padding: const EdgeInsets.all(16),
                        width: constraints.maxWidth * 0.8,
                        height: constraints.maxHeight * 0.25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  data?["from_language"] ?? "Lang 1",
                                  style: GoogleFonts.lato(),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Icon(Iconsax.arrow_right_1),
                                ),
                                Text(
                                  data?["to_language"] ?? "Lang 2",
                                  style: GoogleFonts.lato(),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    data?["word"].toString().toUpperCase() ??
                                        "Error",
                                    style: GoogleFonts.lato(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  const Gap(10),
                                  Text(
                                    data?["translatedText"] ?? "Error",
                                    style: GoogleFonts.lato(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (isLoading) return;

                              var lang = Common().langFromCodeToName();

                              speakWord(
                                data?["translatedText"],
                                lang[widget.learningLang],
                              );

                              Logger().f(widget.learningLang);
                            },
                            icon: Icon(
                              Iconsax.microphone_2,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryFixedVariant,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (isLoading) return;

                              if (!isLiked) {
                                isLiked = true;
                                await TranslationService()
                                    .saveTranslation(data?["translation"]);
                              } else {
                                isLiked = false;
                                await TranslationService().deleteTranslation(
                                  data?["translatedText"],
                                  data?["from_language"],
                                  data?["to_language"],
                                );
                              }

                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor:
                                      isLiked ? Colors.green : Colors.red,
                                  content: Text(
                                    isLiked
                                        ? "Saved to library"
                                        : "Removed from library",
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );

                              setState(() {});
                            },
                            icon: Icon(
                              !isLiked ? Iconsax.heart : Iconsax.heart5,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryFixedVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: !isLoading ? getData : null,
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: Center(
                      child: !isLoading
                          ? Text(
                              "Next",
                              style: GoogleFonts.lato(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            )
                          : LoadingAnimationWidget.stretchedDots(
                              color: Theme.of(context).colorScheme.primary,
                              size: 40,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
