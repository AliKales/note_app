import 'package:flutter/material.dart';
import 'package:note_app/library/UIs/custom_bottom_navbar.dart';
import 'package:note_app/library/funcs.dart';
import 'package:note_app/library/hive/hive_database.dart';
import 'package:note_app/library/provider/provider_pages.dart';
import 'package:note_app/library/simple_uis.dart';
import 'package:note_app/library/values.dart';
import 'package:note_app/pages/lock_page.dart';
import 'package:note_app/pages/main_page/main_page_page_view.dart';
import 'package:provider/provider.dart';

import '../../library/UIs/widget_audio_player.dart';
import '../../library/provider/p_notes.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with _AfteBuild {
  @override
  void initState() {
    super.initState();
    //here after widget build done we go to our func to orginese our stuff as first start in app
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => afterWidgetBuild());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: InkWell(
        onTap: () {
          //here we unfocus textfields when click somewhere
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
                  ///Since we use a bottom nav bar, here we have a PageView and it gets current page index from Provider
                  MainPagePageView(
                      pageCounter: context.watch<ProviderPages>().currentPage),
                  ///Custom Bottom Nav bar gets current page index from provider
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomBottomNavBar(
                        currentPage:
                            context.watch<ProviderPages>().currentPage),
                  ),
                ],
              ),
            ),
            ///This widget is showed when a audio is playing.
            ///It is located on bottom of all widgets
            const WidgetAudioPlayer(),
          ],
        ),
      ),
    );
  }
}

mixin _AfteBuild on State<MainPage> {
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
}
