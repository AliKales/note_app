import 'package:flutter/material.dart';
import 'package:note_app/pages/folder_add_page.dart';
import 'package:note_app/pages/home_page/home_page.dart';
import 'package:note_app/pages/note_add_page.dart';
import 'package:note_app/pages/user_page/user_page.dart';

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

  ///Here we check if parent widget is updated, if yes we get the new pageindex to change PageView after build
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

        ///User is not allowed to change page by scrolling (optional)
        physics: const NeverScrollableScrollPhysics(),
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
