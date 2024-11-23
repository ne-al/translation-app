import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:improve/app/widgets/word_tile.dart';
import 'package:timeago/timeago.dart' as timeago;

class TranslatedWordHistoryTile extends StatelessWidget {
  final Map value;
  final bool isSearchedTimesVisible;
  const TranslatedWordHistoryTile({
    super.key,
    required this.value,
    this.isSearchedTimesVisible = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        WordTile(value: value),
        const Gap(2),
        Padding(
          padding: const EdgeInsets.only(
            right: 12,
            bottom: 4,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              isSearchedTimesVisible
                  ? Text(
                      "(${value["times_searched"]}) \u2022 ",
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    )
                  : const SizedBox.shrink(),
              Text(
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
            ],
          ),
        ),
      ],
    );
  }
}
