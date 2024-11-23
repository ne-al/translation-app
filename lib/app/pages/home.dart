import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:free_dictionary_api_v2/free_dictionary_api_v2.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:improve/app/pages/history.dart';
import 'package:improve/app/widgets/history_listview.dart';
import 'package:improve/app/widgets/translated_word_tile.dart';
import 'package:improve/core/constants/const.dart';
import 'package:improve/core/data/languages.dart';
import 'package:improve/core/services/translation_service.dart';
import 'package:improve/core/services/tts.dart';
import 'package:popover/popover.dart';
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
  late StreamSubscription _librarySubscription;
  Box libraryBox = Hive.box('LIBRARY');
  Translation? translation;
  List<FreeDictionaryResponse> meanings = [];
  bool showTextFieldSuffixIcon = false;

  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _librarySubscription = libraryBox.watch().listen(
      (event) {
        if (event.value == null) {
          setState(() {
            translation = null;
            _messageController.clear();
          });
        }
      },
    );
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

    var data = await TranslationService().translate(
      _messageController.text.trim(),
      translationFromLanguage: lang[selectedFromLng] ?? "auto",
      translationToLanguage: lang[selectedToLng] ?? "en",
    );

    translation = data['translation'];
    meanings = data['meanings'];

    setState(() {});
  }

  @override
  void dispose() {
    _messageController.dispose();
    _librarySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                centerTitle: true,
                title: Text(
                  "PhraseFlow",
                  style: GoogleFonts.lato(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondaryFixedDim,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Gap(18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            fromLanguageDropDown(),
                            Icon(
                              Iconsax.arrow_right_1,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                            toLanguageDropDown(),
                          ],
                        ),
                        const Gap(28),
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
                          style: GoogleFonts.lato(),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context)
                                .colorScheme
                                .surfaceContainerLow,
                            hintText: "What do you want to translate?",
                            hintStyle: GoogleFonts.lato(),
                            suffixIcon: showTextFieldSuffixIcon
                                ? InkWell(
                                    child: const Icon(Iconsax.close_circle),
                                    onTap: () {
                                      _messageController.clear();

                                      translation = null;

                                      setState(() {
                                        showTextFieldSuffixIcon = false;
                                      });
                                    },
                                  )
                                : const SizedBox.shrink(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onSubmitted: (value) async => translateWord(),
                          onChanged: (value) {
                            if (value.trim().length > 3) {
                              setState(() {
                                showTextFieldSuffixIcon = true;
                              });
                            } else {
                              setState(() {
                                showTextFieldSuffixIcon = false;
                              });
                            }
                          },
                        ),
                        const Gap(26),
                        InkWell(
                          onTap: () async {
                            await translateWord();
                          },
                          child: Container(
                            height: 52,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                "Translate",
                                style: GoogleFonts.lato(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inverseSurface,
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
                                  onTap: () => speakWord(
                                    translation!.text,
                                    translation!.targetLanguage.name,
                                  ),
                                  child: TranslatedWordTile(
                                    translation: translation!,
                                  ),
                                ),
                              ),
                        const Gap(30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            taskButton(
                              constraints,
                              Iconsax.box,
                              "Learn new words",
                              "0/10",
                              1,
                            ),
                            taskButton(
                              constraints,
                              Iconsax.magicpen,
                              "Test your knowledge",
                              "0/24",
                              2,
                            ),
                          ],
                        ),
                        const Gap(8),
                        Visibility(
                          visible: libraryBox.isNotEmpty,
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "History",
                                        style: GoogleFonts.lato(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const HistoryPage(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "See all",
                                          style: GoogleFonts.lato(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const HistoryListView(
                                isHomePage: true,
                              ),
                              const Gap(12),
                              Visibility(
                                visible: libraryBox.length >= 8,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Expanded(child: Divider()),
                                        Builder(
                                          builder: (context) {
                                            return InkWell(
                                              onTap: () {
                                                showPopover(
                                                  context: context,
                                                  bodyBuilder: (context) =>
                                                      SizedBox(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        0.6,
                                                    height: MediaQuery.sizeOf(
                                                                context)
                                                            .height *
                                                        0.26,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Center(
                                                        child: Text(
                                                          infoTextHomePage,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              GoogleFonts.lato(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onPrimaryContainer,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primaryContainer,
                                                );
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 2,
                                                ),
                                                child: Icon(
                                                  Iconsax.info_circle,
                                                  size: 16,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        const Expanded(child: Divider()),
                                      ],
                                    ),
                                    const Gap(12),
                                    Text(
                                      creditText,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryFixedDim,
                                      ),
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
    });
  }

  Widget fromLanguageDropDown() {
    return DropdownButtonHideUnderline(
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
            .map((String item) => DropdownMenuItem<String>(
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
            color: Theme.of(context).colorScheme.surfaceContainerLow,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 40,
          width: 136,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
      ),
    );
  }

  Widget toLanguageDropDown() {
    return DropdownButtonHideUnderline(
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
            .map((String item) => DropdownMenuItem<String>(
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
            color: Theme.of(context).colorScheme.surfaceContainerLow,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 40,
          width: 136,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
      ),
    );
  }

  Widget taskButton(
    BoxConstraints constraints,
    IconData icon,
    String text,
    String progress,
    int index,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: constraints.maxHeight * 0.215,
      width: constraints.maxWidth * 0.38,
      decoration: BoxDecoration(
        color: index.isOdd
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          CircleAvatar(
            backgroundColor: index.isOdd
                ? Theme.of(context).colorScheme.primaryFixedDim
                : Theme.of(context).colorScheme.secondaryFixedDim,
            child: Icon(
              icon,
              color: index.isOdd
                  ? Theme.of(context).colorScheme.onPrimaryFixedVariant
                  : Theme.of(context).colorScheme.onSecondaryFixedVariant,
            ),
          ),
          const Expanded(child: SizedBox.shrink()),
          Text(
            text,
            style: GoogleFonts.lato(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: index.isOdd
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
          const Gap(4),
          Text(
            progress,
            style: GoogleFonts.lato(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: index.isOdd
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
