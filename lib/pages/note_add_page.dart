import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:note_app/library/UIs/custom_button.dart';
import 'package:note_app/library/UIs/custom_switch.dart';
import 'package:note_app/library/UIs/custom_textfield.dart';
import 'package:note_app/library/funcs.dart';
import 'package:note_app/library/hive/hive_database.dart';
import 'package:note_app/library/models/m_layers.dart';
import 'package:note_app/library/models/m_note.dart';
import 'package:note_app/library/provider/p_audio_player.dart';
import 'package:note_app/library/provider/p_layers.dart';
import 'package:note_app/library/provider/p_notes.dart';
import 'package:note_app/library/simple_uis.dart';
import 'package:note_app/library/values.dart';
import 'package:provider/provider.dart';

class NoteAddPage extends StatefulWidget {
  const NoteAddPage({Key? key}) : super(key: key);

  @override
  State<NoteAddPage> createState() => _NoteAddPageState();
}

class _NoteAddPageState extends State<NoteAddPage> {
  final TextEditingController _tECTitle = TextEditingController();

  String? password;
  bool isExpiration = false;

  DateTime? dTExpiration;

  List layers = [];

  int audioCounter = 0;

  @override
  Widget build(BuildContext context) {
    layers = Provider.of<PLayers>(context).layersNoteAddPage;
    audioCounter = 0;
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
              ListView.builder(
                itemCount: layers.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  if (layers[index].layerType == LayerType.text) {
                    LayerText layerText = layers[index];
                    return _widgetText(layerText);
                  } else if (layers[index].layerType == LayerType.image) {
                    LayerImage layerImage = layers[index];
                    return _widgetImage(layerImage);
                  } else if (layers[index].layerType == LayerType.audio) {
                    audioCounter++;
                    LayerAudio layerImage = layers[index];
                    return _widgetAudio(layerImage);
                  }

                  return const SizedBox();
                },
              ),
              Align(
                alignment: Alignment.center,
                child: CustomButton.text(
                  textTextButton: "Add Layer",
                  textColor: Colors.blue,
                  margin: EdgeInsets.zero,
                  icon: const Icon(Icons.add, color: Colors.blue),
                  onTap: () => showMobalBottomSheet(),
                ),
              ),
              const Divider(),
              //Custom Switch Lock
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
              //Custom Switch Expiration Date
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
              //Widgets if a folder is selected
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
              SimpleUIs().sizedBoxAsBottomNavBar()
            ],
          ),
        ),
      ),
    );
  }

  Padding _widgetImage(LayerImage layerImage) {
    File file = File(layerImage.path!);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: SimpleUIs.biggerImageOnClick(
              context: context,
              file: file,
              widget: Image.file(
                file,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              Provider.of<PLayers>(context, listen: false)
                  .removeLayersNoteAddPage(layerImage);

              Funcs().deleteFile(layerImage.path!);
            },
            icon: const Icon(Icons.delete_forever, color: Colors.red, size: 32),
          ),
        ],
      ),
    );
  }

  Padding _widgetText(LayerText layerText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CustomTextField(
        maxLines: null,
        label: "Text here",
        iconRight: Icons.delete_forever,
        onRightButtonClicked: () {
          Provider.of<PLayers>(context, listen: false)
              .removeLayersNoteAddPage(layerText);
        },
        onChanged: (val) {
          layerText.text = val;
        },
      ),
    );
  }

  Widget _widgetAudio(LayerAudio layerAudio) {
    return InkWell(
      onTap: () {
        Provider.of<PAudioPlayer>(context, listen: false)
            .startPlayer(layerAudio.path!, audioCounter);
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: cAudioPlayerBackgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(cRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.play_arrow,
              size: 30,
            ),
            Text(
              "Audio $audioCounter",
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.grey),
            ),
            IconButton(
              onPressed: () {
                Provider.of<PLayers>(context, listen: false)
                    .removeLayersNoteAddPage(layerAudio);
                Funcs().deleteFile(layerAudio.path!);
              },
              icon: const Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //FUNCSTIONSS

  void showMobalBottomSheet() {
    //Funcs().unFocus(context);
    if (context.read<PAudioPlayer>().mAudioPlayer.isActive) return;
    SimpleUIs.showCustomModalBottomSheet(
      context: context,
      child: SimpleUIs.customModalBottomSheetForAddLayer(
        context: context,
        onDone: (value) {
          Provider.of<PLayers>(context, listen: false)
              .addLayersNoteAddPage(value);
        },
      ),
    );
  }

  void add() async {
    if (context.read<PAudioPlayer>().mAudioPlayer.isActive) return;

    if (layers == []) return;

    //note id must be null bc it will filled on hive database
    MNote note = MNote(
        itemType: ItemType.note,
        title: _tECTitle.text.trim(),
        layers: layers.toList(),
        password: password,
        createdDate: Funcs().getGMTDateTimeNow(),
        expirationDate: Funcs().getDateTimeLtoG(dTExpiration));

    if (selectedFolderForNote != null) {
      HiveDatabase().addNAFToFolder(note, selectedFolderForNote!);
    } else {
      Provider.of<PNotes>(context, listen: false).addNAF(note);
    }

    clean();
    Funcs().unFocus(context);
  }

  void clean() {
    _tECTitle.clear();
    password = null;
    isExpiration = false;
    dTExpiration = null;
    Provider.of<PLayers>(context, listen: false).clearLayersNoteAddPage();
  }
}
