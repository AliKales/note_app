import 'package:flutter/material.dart';
import 'package:note_app/library/funcs.dart';
import 'package:note_app/library/hive/hive_database.dart';
import 'package:note_app/library/provider/p_layers.dart';
import 'package:note_app/library/provider/p_notes.dart';
import 'package:note_app/library/simple_uis.dart';
import 'package:note_app/library/values.dart';
import 'package:provider/provider.dart';

part 'body_card.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBackgroundColor,
      appBar: _appBar(context),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            _widgetBodyCardLock(),
            const Divider(),
            _BodyCard(
              text: "Clear All Notes",
              iconData: Icons.delete_forever,
              onTap: () async {
                if (!await SimpleUIs.showDialogYesNo(context: context)) return;

                SimpleUIs().showProgressIndicator(context);

                await Funcs().clearAllNotes();

                Navigator.pop(context);

                Provider.of<PNotes>(context, listen: false).clearNAFs();
              },
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: cBackgroundColor,
      elevation: 0.3,
      title: Text(
        appName,
        style: Theme.of(context)
            .textTheme
            .headline5!
            .copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  _widgetBodyCardLock() {
    if (appPassword == null) {
      return _BodyCard(
        text: "Lock App",
        iconData: Icons.lock,
        onTap: () async {
          String? result = await SimpleUIs.showTextInput(
              context: context, label: "Password", buttonText: "Lock");
          if (result == null) return;

          result = result.trim();

          await HiveDatabase().putValueToDB("appPassword", result);
          appPassword = result;
          setState(() {});
        },
      );
    } else {
      return _BodyCard(
        text: "Unlock App",
        iconData: Icons.lock_open,
        onTap: () async {
          await HiveDatabase().putValueToDB("appPassword", null);
          setState(() {
            appPassword = null;
          });
        },
      );
    }
  }
}
