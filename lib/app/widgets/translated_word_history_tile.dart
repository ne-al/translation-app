import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:timeago/timeago.dart' as timeago;

class TranslatedWordHistoryTile extends StatelessWidget {
  final Map value;
  const TranslatedWordHistoryTile({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Card(
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
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primaryFixedDim,
                        ),
                      ),
                      const Gap(6),
                      Text(
                        value['source_text'],
                        textAlign: TextAlign.start,
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(Iconsax.arrow_right_1),
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
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primaryFixedDim,
                        ),
                      ),
                      const Gap(6),
                      Text(
                        value['text'],
                        textAlign: TextAlign.end,
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        const Gap(2),
        Padding(
          padding: const EdgeInsets.only(
            right: 12,
            bottom: 4,
          ),
          child: Text(
            timeago.format(
              DateTime.fromMillisecondsSinceEpoch(
                value['time'],
              ),
            ),
            style: GoogleFonts.lato(
              fontSize: 12,
              fontWeight: FontWeight.w300,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
