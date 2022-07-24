import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:note_app/library/UIs/custom_button.dart';
import 'package:note_app/library/UIs/custom_icon_text_button.dart';
import 'package:note_app/library/UIs/custom_switch.dart';
import 'package:note_app/library/UIs/widget_folder_picker.dart';
import 'package:note_app/library/UIs/widget_note_picker.dart';
import 'package:note_app/library/funcs.dart';
import 'package:note_app/library/hive/hive_database.dart';
import 'package:note_app/library/models/m_folder.dart';
import 'package:note_app/library/models/m_note.dart';
import 'package:note_app/library/provider/p_layers.dart';
import 'package:note_app/library/provider/p_notes.dart';
import 'package:note_app/library/provider/provider_pages.dart';
import 'package:note_app/library/simple_uis.dart';
import 'package:note_app/library/values.dart';
import 'package:note_app/pages/note_details_page.dart';
import 'package:provider/provider.dart';

class HomePageBody extends StatefulWidget {
  const HomePageBody({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  final ScrollController _sC = ScrollController();

  List<Widget> folderWidgets = [];

  MFolder? lastFolder;

  double scrollPos = 0;

  @override
  Widget build(BuildContext context) {
    List nAFs = Provider.of<PNotes>(context).nAFs;

    return Expanded(
      flex: 2,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: ListView(
          controller: _sC,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: widgetListViewNotesAndFolders(nAFs, false)),
            ...folderWidgets
          ],
        ),
      ),
    );
  }

  SizedBox widgetFolder(MFolder folder) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                    child: Text(
                      folder.title ?? "--",
                      maxLines: null,
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                //Icon More Button
                IconButton(
                  onPressed: onMoreClicked,
                  icon: const Icon(Icons.more_vert_sharp, color: Colors.black),
                ),
                //Icon Back To Start
                // if (shownFolderCounter > 1)
                IconButton(
                  onPressed: () {
                    folderWidgets.clear();
                    setState(() {});
                    _sC.animateTo(0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  },
                  icon: const Icon(Icons.keyboard_double_arrow_left_outlined,
                      color: Colors.black),
                ),
                //Back Button Icon here
                SimpleUIs.customAppbarBackButton(
                  context: context,
                  onTap: () {
                    shownFolderCounter--;
                    setState(() {
                      folderWidgets.removeLast();
                    });
                    _sC.animateTo((_sC.position.maxScrollExtent - scrollPos),
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeIn);
                  },
                ),
              ],
            ),
            Wrap(
              children: [
                CustomButton.text(
                  textTextButton: "Create Note",
                  textColor: Colors.blue,
                  margin: EdgeInsets.zero,
                  onTap: () {
                    selectedFolderForNote = folder;
                    Provider.of<ProviderPages>(context, listen: false)
                        .changePage(1);
                  },
                ),
                CustomButton.text(
                  textTextButton: "Create Folder",
                  textColor: Colors.blue,
                  margin: EdgeInsets.zero,
                  onTap: () {
                    selectedFolderForNote = folder;
                    Provider.of<ProviderPages>(context, listen: false)
                        .changePage(2);
                  },
                ),
              ],
            ),
            widgetListViewNotesAndFolders(
                HiveDatabase().getTitles(folder.nAFIds ?? []), true),
          ],
        ),
      ),
    );
  }

  Widget widgetListViewNotesAndFolders(List<dynamic> nAFs, bool isFromFolder) {
    return ListView.builder(
      itemCount: nAFs.length + 1,
      shrinkWrap: true,
      itemBuilder: (_, index) {
        //Widget of notes' titles
        if (index == nAFs.length) {
          return SimpleUIs().sizedBoxAsBottomNavBar();
        }

        var nAF = nAFs[index];

        if (nAF.itemType == ItemType.note) {
          return WidgetNotePicker(
            note: nAFs[index],
            onLongPress: () => onLongPress(nAF),
            onTap: () => onTapNote(nAF, isFromFolder),
          );
        } else {
          return WidgetFolderPicker(
            folder: nAF,
            onTap: () => onTapFolder(nAF),
            onLongPress: () => onLongPress(nAF),
          );
        }
      },
    );
  }

  Widget _widgetTextForModalBottomSheet(context, String text1, String text2) {
    return SimpleUIs.widgetTextForModalBottomSheet(
        context: context, text1: text1, text2: text2);
  }
  //FUNCTIONS

  Future onTapNote(MNote note, bool isFromFolder) async {
    if (note.expirationDate != null) {
      if (Funcs().checkExpiration(note.expirationDate)) {
        Funcs().showSnackBar(context, "This note is not available anymore!");
        return;
      }
    }
    if (note.password != null) {
      String? text = await SimpleUIs.showTextInput(
          context: context, label: "Password", buttonText: "Enter");

      if (text == null || text.trim() != note.password) {
        if (text != null) Funcs().showSnackBar(context, "Wrong Password");
        return;
      }
    }
    Provider.of<PLayers>(context, listen: false).layersNoteDetailsPage =
        note.layers ?? [];
    await Funcs().navigatorPush(
        context, NoteDetailsPage(note: note, isFromFolder: isFromFolder));

    setState(() {});
  }

  Future onTapFolder(MFolder folder) async {
    if (folder.expirationDate != null) {
      if (Funcs().checkExpiration(folder.expirationDate)) {
        Funcs().showSnackBar(context, "This folder is not available anymore!");
        return;
      }
    }
    if (folder.password != null) {
      String? text = await SimpleUIs.showTextInput(
          context: context, label: "Password", buttonText: "Enter");

      if (text == null || text.trim() != folder.password) {
        if (text != null) Funcs().showSnackBar(context, "Wrong Password");
        return;
      }
    }

    lastFolder = folder;

    folderWidgets.add(widgetFolder(folder));

    shownFolderCounter++;

    setState(() {});

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (scrollPos == 0) scrollPos = _sC.position.maxScrollExtent;

      _sC.animateTo(_sC.position.maxScrollExtent,
          duration: const Duration(milliseconds: 700), curve: Curves.easeIn);
    });
  }

  Future onLongPress(nAF) async {
    SimpleUIs.showCustomModalBottomSheet(
      context: context,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconTextButton(
                text: "Delete",
                iconData: Icons.delete_forever,
                onTap: () => deleteNAF(nAF)),
          ],
        ),
      ),
    );
  }

  void deleteNAF(nAF) async {
    Navigator.pop(context);
    bool result = await SimpleUIs.showDialogYesNo(context: context);

    if (result) {
      Provider.of<PNotes>(context, listen: false).deleteNAF(nAF);
    }
  }

  void onMoreClicked() {
    SimpleUIs.showCustomModalBottomSheet(
      context: context,
      child: _customModalBottomSheet(context),
    );
  }

  Widget _customModalBottomSheet(context) {
    String? description;
    return StatefulBuilder(builder: (context, sT) {
      return Column(
        children: [
          CustomSwitch(
            valueBool: lastFolder!.password != null,
            text: "Lock:",
            onChanded: (value) async {
              if (lastFolder!.password != null) {
                sT(() {
                  lastFolder!.password = null;
                });
                return;
              }
              String? text = await SimpleUIs.showTextInput(
                  context: context, label: "Password", buttonText: "Lock");
              if (text != null) {
                sT(() {
                  lastFolder!.password = text;
                });
              }
            },
          ),
          CustomSwitch(
            valueBool: lastFolder!.expirationDate != null,
            text: "Expiration Date:",
            onChanded: (value) {
              if (lastFolder!.expirationDate != null) {
                sT(() {
                  lastFolder!.expirationDate = null;
                });
                HiveDatabase().ediFirsttNAF(lastFolder!);
                return;
              }
              DatePicker.showDatePicker(
                context,
                minTime: DateTime.now(),
                onConfirm: (d) {
                  sT(() {
                    lastFolder!.expirationDate = Funcs().getDateTimeGtoL(d);
                  });
                  HiveDatabase().ediFirsttNAF(lastFolder!);
                },
              );
            },
          ),
          const Divider(),
          _widgetTextForModalBottomSheet(
              context,
              "Last Update",
              Funcs().getDateTimeAsText(
                  Funcs().getDateTimeGtoL(lastFolder!.lastUpdateDate))),
          _widgetTextForModalBottomSheet(
              context,
              "Create Date",
              Funcs().getDateTimeAsText(
                  Funcs().getDateTimeGtoL(lastFolder!.createdDate))),
          _widgetTextForModalBottomSheet(
              context,
              "Expiration Date",
              Funcs().getDateTimeAsText(
                  Funcs().getDateTimeGtoL(lastFolder!.expirationDate))),
          const Divider(),
          CustomIconTextButton(
            text: "Edit Title",
            iconData: Icons.edit,
            onTap: () async {
              String? result = await SimpleUIs.showTextInput(
                  context: context, label: "Title", buttonText: "Save");
              if (result == null) return;
              lastFolder!.title = result;

              if (shownFolderCounter > 1) {
                await HiveDatabase().editNAFToFolder(lastFolder);
              } else {
                await HiveDatabase().ediFirsttNAF(lastFolder);
              }
            },
          ),
          CustomIconTextButton(
            text: "Edit Description",
            iconData: Icons.edit,
            onTap: () async {
              String? result = await SimpleUIs.showTextInput(
                  context: context, label: "Description", buttonText: "Save");
              if (result == null) return;
              lastFolder!.description = result;
              description = result;

              if (shownFolderCounter > 1) {
                await HiveDatabase().editNAFToFolder(lastFolder);
              } else {
                await HiveDatabase().ediFirsttNAF(lastFolder);
              }
            },
          ),
          const Divider(),
          if (description == null)
            CustomButton.text(
              textTextButton: "See Description",
              textColor: Colors.blue,
              onTap: () {
                sT(() {
                  description = lastFolder!.description;
                });
              },
            )
          else
            Text(
              description!,
              style: Theme.of(context).textTheme.headline6,
            ),
          SizedBox(height: MediaQuery.of(context).size.height / 8),
        ],
      );
    });
  }
}
