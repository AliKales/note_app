import 'package:flutter/material.dart';
import 'package:note_app/library/UIs/custom_bottom_navbar.dart';
import 'package:note_app/library/funcs.dart';
import 'package:note_app/library/hive/hive_database.dart';
import 'package:note_app/library/provider/provider_pages.dart';
import 'package:note_app/library/simple_uis.dart';
import 'package:note_app/library/values.dart';
import 'package:note_app/pages/lock_page.dart';
import 'package:note_app/pages/main_page/main_page_page_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../library/UIs/widget_audio_player.dart';
import '../../library/provider/p_notes.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //int _currentPage = 0;

  ///[isSwiping] is for cheking if pace change comes from swipe to page
  bool isSwiping = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => afterWidgetBuild());
  }

  afterWidgetBuild() async {
    SimpleUIs().showProgressIndicator(context);
    pathToAppFolder = await Funcs().getAppDocPath();
    if (await HiveDatabase().getValueFromDB("firstStart") ?? true) {
      await Funcs().createFolders();
      await HiveDatabase().putValueToDB("firstStart", false);
    }

    var result = await HiveDatabase().getValueFromDB("appPassword");

    appPassword = result;

    Navigator.pop(context);

    if (result != null) {
      await Funcs().navigatorPush(context, LockPage(password: appPassword!));
    }

    Provider.of<PNotes>(context, listen: false).setNAFs(HiveDatabase().getNAFs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: InkWell(
        onTap: () {
          Funcs().unFocus(context);
        },
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        overlayColor: null,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  MainPagePageView(
                      pageCounter: context.watch<ProviderPages>().currentPage),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomBottomNavBar(
                        currentPage:
                            context.watch<ProviderPages>().currentPage),
                  ),
                ],
              ),
            ),
            const WidgetAudioPlayer(),
          ],
        ),
      ),
    );
  }
}
