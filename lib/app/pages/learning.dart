import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:improve/core/services/random_word_service.dart';
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
      data = response;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
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
                            onPressed: () {
                              if (isLoading) return;
                            },
                            icon: Icon(
                              Iconsax.heart,
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
