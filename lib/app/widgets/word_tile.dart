import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class WordTile extends StatelessWidget {
  final Map value;
  const WordTile({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle languageName = GoogleFonts.lato(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.primaryFixedDim,
    );

    TextStyle translatedWord = GoogleFonts.lato(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).colorScheme.secondaryFixedDim,
    );
    return Card(
      elevation: 2,
      shadowColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${value['from_language']}",
                    textAlign: TextAlign.start,
                    style: languageName,
                  ),
                  const Gap(6),
                  Text(
                    value['source_text'],
                    textAlign: TextAlign.start,
                    style: translatedWord,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                Iconsax.arrow_right_1,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${value['to_language']}",
                    textAlign: TextAlign.end,
                    style: languageName,
                  ),
                  const Gap(6),
                  Text(
                    value['text'],
                    textAlign: TextAlign.end,
                    style: translatedWord,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
