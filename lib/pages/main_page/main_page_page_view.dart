import 'package:flutter/material.dart';
import 'package:note_app/pages/folder_add_page.dart';
import 'package:note_app/pages/home_page/home_page.dart';
import 'package:note_app/pages/note_add_page.dart';
import 'package:note_app/pages/user_page/user_page.dart';
import 'package:provider/provider.dart';

import '../../library/provider/provider_pages.dart';

class MainPagePageView extends StatefulWidget {
  const MainPagePageView({
    Key? key,
    required this.pageCounter,
  }) : super(key: key);

  final int pageCounter;

  @override
  State<MainPagePageView> createState() => _MainPagePageViewState();
}

class _MainPagePageViewState extends State<MainPagePageView> {
  final PageController _pageController =
      PageController(initialPage: 0, keepPage: true);

  @override
  void didUpdateWidget(covariant MainPagePageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageCounter == widget.pageCounter) return;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _pageController.jumpToPage(widget.pageCounter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (value) {
          Provider.of<ProviderPages>(context, listen: false).changePage(value);
        },
        children: const [
          HomePage(),
          NoteAddPage(),
          FolderAddPage(),
          UserPage(),
        ],
      ),
    );
  }
}
