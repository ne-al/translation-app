import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:improve/app/pages/history.dart';
import 'package:improve/app/widgets/history_listview.dart';
import 'package:improve/app/widgets/translated_word_tile.dart';
import 'package:improve/core/data/languages.dart';
import 'package:improve/core/services/translation_service.dart';
import 'package:translator/translator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> allDropDownLanguages = [];
  String? selectedFromLng = "Auto";
  String? selectedToLng = "Hindi";
  Map lang = {};
  FlutterTts flutterTts = FlutterTts();
  Box libraryBox = Hive.box('LIBRARY');
  Translation? translation;

  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    for (var language in allLanguages) {
      allDropDownLanguages.add(language['name'].toString());
    }

    for (var e in allLanguages) {
      lang.addAll({e['name']: e['code']});
    }

    setState(() {});
  }

  Future<void> translateWord() async {
    if (_messageController.text.isEmpty) return;
    _messageFocusNode.unfocus();
    translation = await TranslationService().translate(
      _messageController.text,
      translationFromLanguage: lang[selectedFromLng] ?? "auto",
      translationToLanguage: lang[selectedToLng] ?? "en",
    );

    setState(() {});
  }

  Future<void> speakWord(Translation word) async {
    String ttsLang;

    await flutterTts.setSpeechRate(0.5);

    switch (lang[selectedToLng]) {
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

    await flutterTts.speak(word.text);
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              title: Text(
                "PhraseFlow",
                style: GoogleFonts.lato(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondaryFixedDim,
                ),
              ),
              actions: [
                InkWell(
                  child: Icon(
                    Iconsax.book_saved4,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoryPage(),
                    ),
                  ),
                ),
                const Gap(12),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Gap(12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: Text(
                                'Select Item',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              items: allDropDownLanguages
                                  .map(
                                      (String item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ))
                                  .toList(),
                              value: selectedFromLng,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedFromLng = value;
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerLow,
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                height: 40,
                                width: 136,
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                              ),
                            ),
                          ),
                          const Icon(Iconsax.arrow_right_1),
                          //! To
                          DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              style: GoogleFonts.lato(),
                              isExpanded: true,
                              hint: Text(
                                'Select Item',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              items: allDropDownLanguages
                                  .map(
                                      (String item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ))
                                  .toList(),
                              value: selectedToLng,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedToLng = value;
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerLow,
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                height: 40,
                                width: 136,
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(24),
                      TextField(
                        controller: _messageController,
                        focusNode: _messageFocusNode,
                        autocorrect: true,
                        autofocus: false,
                        canRequestFocus: true,
                        enableIMEPersonalizedLearning: false,
                        enableSuggestions: true,
                        keyboardType: TextInputType.text,
                        maxLines: null,
                        obscureText: false,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.surfaceContainerLow,
                          hintText: "What do you want to translate?",
                          hintStyle: GoogleFonts.lato(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: (value) async => translateWord(),
                      ),
                      const Gap(24),
                      InkWell(
                        onTap: () async {
                          await translateWord();
                        },
                        child: Container(
                          height: 52,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Translate",
                              style: GoogleFonts.lato(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                            ),
                          ),
                        ),
                      ),
                      translation == null
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: InkWell(
                                onTap: () => speakWord(translation!),
                                child: TranslatedWordTile(
                                  translation: translation!,
                                ),
                              ),
                            ),
                      Visibility(
                        visible: libraryBox.isNotEmpty,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              child: Row(
                                children: [
                                  const Expanded(child: Divider()),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(
                                      "History",
                                      style: GoogleFonts.lato(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ),
                                  const Expanded(child: Divider()),
                                ],
                              ),
                            ),
                            const HistoryListView(
                              isHomePage: true,
                            ),
                            const Gap(6),
                            const Divider(),
                            Visibility(
                              visible: libraryBox.length >= 10,
                              child: Column(
                                children: [
                                  const Gap(12),
                                  Text(
                                    "This is only your latest 10 words history.\nTo view your complete history check the top right corner and click on the icon.",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(),
                                  ),
                                  const Gap(12),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
