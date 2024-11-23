import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:improve/app/widgets/history_listview.dart';
import 'package:improve/core/services/translation_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: Text(
                    "History",
                    style: GoogleFonts.lato(),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () async {
                        await TranslationService().clearAllTranslations();
                      },
                      icon: const Icon(Iconsax.trash),
                    )
                  ],
                  bottom: const TabBar(
                    tabs: [
                      Tab(text: "Latest"),
                      Tab(text: "Most Searched"),
                    ],
                  ),
                ),
              ];
            },
            body: const Padding(
              padding: EdgeInsets.only(top: 12),
              child: TabBarView(
                children: [
                  HistoryListView(
                    isSortedByTime: true,
                  ),
                  HistoryListView(
                    isSortedByTime: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
