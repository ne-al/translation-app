import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:improve/app/pages/learning.dart';
import 'package:improve/core/constants/const.dart';

class NewWordsPage extends StatefulWidget {
  const NewWordsPage({super.key});

  @override
  State<NewWordsPage> createState() => _NewWordsPageState();
}

class _NewWordsPageState extends State<NewWordsPage> {
  int selectedIndex = 0;

  List availableLanguages = [
    {
      "name": "Hindi",
      "code": "hi",
      "is_selected": false,
      "description":
          "One of the official language of India, connecting you to a rich heritage and culture.",
      "flag_url":
          "https://cdn.britannica.com/97/1597-050-008F30FA/Flag-India.jpg",
    },
    // {
    //   "name": "English",
    //   "code": "en",
    //   "is_selected": false,
    //   "description":
    //       "The global language of business, technology, and international communication.",
    //   "flag_url":
    //       "https://cdn.britannica.com/25/4825-050-977D8C5E/Flag-United-Kingdom.jpg",
    // },
    {
      "name": "Spanish",
      "code": "es",
      "is_selected": false,
      "description":
          "The second most spoken language, key to exploring Latin America and Spain.",
      "flag_url":
          "https://cdn.britannica.com/36/4336-050-056AC114/Flag-Spain.jpg",
    },
    {
      "name": "French",
      "code": "fr",
      "is_selected": false,
      "description":
          "A global language of diplomacy, widely spoken in Europe, Africa, and Canada.",
      "flag_url":
          "https://cdn.britannica.com/82/682-050-8AA3D6A6/Flag-France.jpg",
    },
    {
      "name": "German",
      "code": "de",
      "is_selected": false,
      "description":
          "Europe's most spoken native language, vital for science and business.",
      "flag_url":
          "https://cdn.britannica.com/97/897-050-0BFECDA5/Flag-Germany.jpg",
    },
    {
      "name": "Italian",
      "code": "it",
      "is_selected": false,
      "description":
          "The language of art, culture, and cuisine, connecting you to Italy’s heritage.",
      "flag_url":
          "https://cdn.britannica.com/59/1759-050-FCD5A574/Flag-Italy.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(10),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_back_ios_new,
                            size: 16,
                          ),
                          const Gap(6),
                          Text(
                            "Back",
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.w500, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    const Gap(18),
                    Text(
                      "Choose a language:",
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w600,
                        fontSize: 28,
                      ),
                    ),
                    const Gap(12),
                    ListView.separated(
                      separatorBuilder: (context, index) => const Gap(12),
                      itemCount: availableLanguages.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        Map data = availableLanguages[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerLow,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              width: 0.5,
                              color: selectedIndex == index
                                  ? Theme.of(context).colorScheme.outline
                                  : Colors.transparent,
                            ),
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: CachedNetworkImage(
                                imageUrl: data["flag_url"],
                                width: 50,
                                height: 36,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              data["name"],
                              style: GoogleFonts.lato(
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(
                              data["description"],
                              style: GoogleFonts.lato(),
                            ),
                            onTap: () {
                              selectedIndex = index;

                              setState(() {});
                            },
                          ),
                        );
                      },
                    ),
                    const Gap(30),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LearningPage(
                            learningLang: availableLanguages[selectedIndex]
                                    ["code"] ??
                                "en",
                          ),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onPrimary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            "Start learning ${availableLanguages[selectedIndex]["name"]}",
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 30,
                        right: 20,
                        left: 20,
                      ),
                      child: Text(
                        otherLangWarning,
                        style: GoogleFonts.lato(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
