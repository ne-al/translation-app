import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:improve/app/widgets/translated_word_history_tile.dart';
import 'package:improve/core/services/translation_service.dart';
import 'package:improve/core/services/tts.dart';

class HistoryListView extends StatelessWidget {
  final bool isHomePage;
  final bool isSortedByTime;

  const HistoryListView({
    super.key,
    this.isHomePage = false,
    this.isSortedByTime = true,
  });

  @override
  Widget build(BuildContext context) {
    Box libraryBox = Hive.box('LIBRARY');
    return ValueListenableBuilder(
      valueListenable: libraryBox.listenable(),
      builder: (context, value, child) {
        // Get the list of data
        List<Map> sortedData = List<Map>.from(value.values);

        // Sort the data by the 'time' field in descending order (latest first)
        isSortedByTime
            ? sortedData.sort((a, b) {
                int timeA = a['time'];
                int timeB = b['time'];
                return timeB.compareTo(timeA);
              })
            : sortedData.sort((a, b) {
                int searchedA = a['times_searched'];
                int searchedB = b['times_searched'];
                return searchedB.compareTo(searchedA);
              });

        sortedData =
            isHomePage ? sortedData.take(10).toList() : sortedData.toList();

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sortedData.length,
          itemBuilder: (BuildContext context, int index) {
            Map data = sortedData[index];
            return InkWell(
              onTap: () => speakWord(data["text"], data["to_language"]),
              onLongPress: () {
                _showDeleteCopyDialog(context, data);
              },
              child: TranslatedWordHistoryTile(
                value: data,
                isSearchedTimesVisible: !isSortedByTime,
              ),
            );
          },
        );
      },
    );
  }
}

Future _showDeleteCopyDialog(BuildContext context, Map data) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Delete or Copy?"),
      content: const Text("Do you want to delete or copy this word?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            await TranslationService().deleteTranslation(
              data["text"],
              data["from_language"],
              data["to_language"],
            );
            if (!context.mounted) return;
            Navigator.pop(context);
          },
          child: const Text("Delete"),
        ),
        TextButton(
          onPressed: () async {
            await Clipboard.setData(
              ClipboardData(text: data["text"]),
            );

            if (!context.mounted) return;
            Navigator.pop(context);
          },
          child: const Text("Copy"),
        ),
      ],
      actionsAlignment: MainAxisAlignment.end,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    ),
  );
}
