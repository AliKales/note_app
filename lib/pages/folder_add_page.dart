import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:note_app/library/UIs/custom_button.dart';
import 'package:note_app/library/UIs/custom_switch.dart';
import 'package:note_app/library/UIs/custom_textfield.dart';
import 'package:note_app/library/funcs.dart';
import 'package:note_app/library/hive/hive_database.dart';
import 'package:note_app/library/models/m_folder.dart';
import 'package:note_app/library/provider/p_notes.dart';
import 'package:note_app/library/simple_uis.dart';
import 'package:note_app/library/values.dart';
import 'package:provider/provider.dart';

class FolderAddPage extends StatefulWidget {
  const FolderAddPage({Key? key}) : super(key: key);

  @override
  State<FolderAddPage> createState() => FolderAddPageState();
}

class FolderAddPageState extends State<FolderAddPage> {
  final TextEditingController _tECTitle = TextEditingController();
  final TextEditingController _tECDescription = TextEditingController();

  String? password;
  bool isExpiration = false;

  DateTime? dTExpiration;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                  textEditingController: _tECTitle,
                  label: "Title",
                  maxLines: null),
              const Divider(),
              CustomTextField(
                  textEditingController: _tECDescription,
                  label: "Description",
                  maxLines: null),
              const Divider(),
              CustomSwitch(
                text: "Lock:",
                valueBool: password != null,
                onChanded: (value) async {
                  if (password != null) {
                    setState(() {
                      password = null;
                    });
                    return;
                  }
                  String? text = await SimpleUIs.showTextInput(
                      context: context, label: "Password", buttonText: "Lock");
                  if (text != null) {
                    setState(() {
                      password = text;
                    });
                  }
                },
              ),
              CustomSwitch(
                text: "Expiration Date:",
                dTExpiration: dTExpiration,
                valueBool: isExpiration,
                onChanded: (values) {
                  if (isExpiration) {
                    setState(() {
                      isExpiration = false;
                      dTExpiration = null;
                    });
                    return;
                  }
                  DatePicker.showDatePicker(
                    context,
                    minTime: DateTime.now(),
                    onConfirm: (d) {
                      d = d.add(const Duration(hours: 12));
                      dTExpiration = Funcs().getDateTimeLtoG(d);
                      setState(() {
                        isExpiration = true;
                      });
                    },
                  );
                },
              ),
              if (selectedFolderForNote != null) ...[
                const Divider(),
                Row(
                  children: [
                    const Icon(
                      Icons.folder,
                      color: cFolderColor,
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.black),
                    Expanded(
                      child: Text(selectedFolderForNote!.title ?? "",
                          maxLines: null,
                          style: Theme.of(context).textTheme.headline6),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          selectedFolderForNote = null;
                        });
                      },
                      icon: const Icon(Icons.close, color: Colors.black),
                    ),
                  ],
                ),
              ],
              CustomButton(text: "Add", onTap: add),
            ],
          ),
        ),
      ),
    );
  }

  void add() {
    if (_tECDescription.text.trim() == "") return;

    MFolder folder = MFolder(
        itemType: ItemType.folder,
        title: _tECTitle.text.trim(),
        description: _tECDescription.text.trim(),
        password: password,
        createdDate: Funcs().getGMTDateTimeNow(),
        expirationDate: Funcs().getDateTimeLtoG(dTExpiration));

    if (selectedFolderForNote != null) {
      HiveDatabase().addNAFToFolder(folder, selectedFolderForNote!);
    } else {
      Provider.of<PNotes>(context, listen: false).addNAF(folder);
    }

    clean();
  }

  void clean() {
    _tECTitle.clear();
    _tECDescription.clear();
    password = null;
    isExpiration = false;
    dTExpiration = null;
    setState(() {});
  }
}
