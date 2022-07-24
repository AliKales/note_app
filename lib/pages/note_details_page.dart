import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:note_app/library/UIs/custom_button.dart';
import 'package:note_app/library/UIs/custom_icon_text_button.dart';
import 'package:note_app/library/UIs/custom_switch.dart';
import 'package:note_app/library/UIs/custom_textfield.dart';
import 'package:note_app/library/UIs/widget_audio_player.dart';
import 'package:note_app/library/funcs.dart';
import 'package:note_app/library/hive/hive_database.dart';
import 'package:note_app/library/models/m_layers.dart';
import 'package:note_app/library/models/m_note.dart';
import 'package:note_app/library/provider/p_layers.dart';
import 'package:note_app/library/simple_uis.dart';
import 'package:note_app/library/values.dart';
import 'package:provider/provider.dart';

import '../library/provider/p_audio_player.dart';

class NoteDetailsPage extends StatefulWidget {
  const NoteDetailsPage(
      {Key? key, required this.note, this.isFromFolder = false})
      : super(key: key);

  final MNote note;
  final bool isFromFolder;

  @override
  State<NoteDetailsPage> createState() => _NoteDetailsPageState();
}

class _NoteDetailsPageState extends State<NoteDetailsPage> {
  bool isEditing = false;

  final TextEditingController _tECTitle = TextEditingController();
  final TextEditingController _tECNote = TextEditingController();

  List layers = [];

  List pathsToDelete = [];

  int audioCounter = 0;

  int _startDrag = 0;
  int sensitivity = 10;
  int width = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tECTitle.text = widget.note.title ?? "";
  }

  @override
  Widget build(BuildContext context) {
    audioCounter = 0;
    layers = Provider.of<PLayers>(context).layersNoteDetailsPage;
    width = MediaQuery.of(context).size.width.toInt();

    return Scaffold(
      backgroundColor: cBackgroundColor,
      body: GestureDetector(
        onHorizontalDragStart: (details) {
          _startDrag = details.localPosition.dx.toInt();
        },
        onHorizontalDragUpdate: (details) {
          // Note: Sensitivity is integer used when you don't want to mess up vertical drag
          if (_startDrag <= (width / 5) && details.delta.dx > sensitivity) {
            // Right Swipe
            Navigator.of(context).pop();
          } else if (_startDrag >= (width - (width / 5)) &&
              details.delta.dx < -sensitivity) {
            //Left Swipe
            Navigator.of(context).pop();
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(cPaddingPage),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //tihs makes column reach 100% in horizantal direction
                const SizedBox(width: double.maxFinite),
                //Widget Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _widgetTextTitle(),
                    //This icon is both for More and Add widgets
                    IconButton(
                      onPressed: () async {
                        if (isEditing) {
                          showMobalBottomSheetForAddLayer();
                        } else {
                          onMoreClicked(context);
                        }
                      },
                      icon: Icon(
                          isEditing ? Icons.add : Icons.more_horiz_rounded,
                          color: Colors.black),
                    )
                  ],
                ),
                const Divider(),
                Expanded(
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification:
                        (OverscrollIndicatorNotification overscroll) {
                      overscroll.disallowIndicator();
                      return true;
                    },
                    child: ListView.builder(
                      itemCount: layers.length,
                      itemBuilder: (context, i) {
                        if (layers[i].layerType == LayerType.text) {
                          return _widgetText(layers[i]);
                        } else if (layers[i].layerType == LayerType.image) {
                          return _widgetImage(layers[i]);
                        } else if (layers[i].layerType == LayerType.audio) {
                          audioCounter++;
                          LayerAudio layerAudio = layers[i];
                          return _widgetAudio(layerAudio);
                        }

                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                if (isEditing)
                  CustomButton(
                    text: "Save",
                    onTap: save,
                  ),
                const WidgetAudioPlayer(isRadiused: true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _widgetText(LayerText layerText) {
    if (isEditing) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: CustomTextField(
          label: "Note",
          maxLines: null,
          iconRight: Icons.delete,
          onRightButtonClicked: () {
            Provider.of<PLayers>(context)
                .removeLayersNoteDetailsPage(layerText);
          },
          textEditingController: TextEditingController(text: layerText.text),
          onChanged: (val) {
            layerText.text = val;
          },
        ),
      );
    }
    return Text(layerText.text ?? "",
        style: Theme.of(context).textTheme.headline6);
  }

  Widget _widgetImage(LayerImage layerImage) {
    File file = File(layerImage.path!);
    if (isEditing) {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Expanded(child: Image.file(file)),
            IconButton(
              onPressed: () {
                Provider.of<PLayers>(context)
                    .removeLayersNoteDetailsPage(layerImage);
                    
                pathsToDelete.add(layerImage.path);
              },
              icon:
                  const Icon(Icons.delete_forever, color: Colors.red, size: 32),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SimpleUIs.biggerImageOnClick(
          context: context,
          file: file,
          widget: Image.file(File(layerImage.path!))),
    );
  }

  Widget _widgetTextTitle() {
    if (isEditing) {
      return Expanded(
        child: CustomTextField(
          label: "Title",
          maxLines: null,
          textEditingController: _tECTitle,
        ),
      );
    }
    return Expanded(
      child: Text(
        widget.note.title ?? "",
        maxLines: null,
        style: Theme.of(context)
            .textTheme
            .headline4!
            .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
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
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(
                Icons.play_arrow,
                size: 30,
              ),
            ),
            Padding(
              padding: isEditing
                  ? EdgeInsets.zero
                  : const EdgeInsets.only(right: 12),
              child: Text(
                "Audio $audioCounter",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.grey),
              ),
            ),
            if (isEditing)
              IconButton(
                onPressed: () {
                  Provider.of<PLayers>(context, listen: false)
                      .removeLayersNoteAddPage(layerAudio);
                  pathsToDelete.add(layerAudio.path!);
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

  Widget _customModalBottomSheet(context) {
    return StatefulBuilder(builder: (context, sT) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSwitch(
            valueBool: widget.note.password != null,
            text: "Lock:",
            onChanded: (value) async {
              if (widget.note.password != null) {
                sT(() {
                  widget.note.password = null;
                });
                return;
              }
              String? text = await SimpleUIs.showTextInput(
                  context: context, label: "Password", buttonText: "Lock");
              if (text != null) {
                sT(() {
                  widget.note.password = text;
                });
              }
            },
          ),
          CustomSwitch(
            valueBool: widget.note.expirationDate != null,
            text: "Expiration Date:",
            onChanded: (value) {
              if (widget.note.expirationDate != null) {
                sT(() {
                  widget.note.expirationDate = null;
                });
                HiveDatabase().ediFirsttNAF(widget.note);
                return;
              }
              DatePicker.showDatePicker(
                context,
                minTime: DateTime.now(),
                onConfirm: (d) {
                  sT(() {
                    widget.note.expirationDate = Funcs().getDateTimeGtoL(d);
                  });
                  HiveDatabase().ediFirsttNAF(widget.note);
                },
              );
            },
          ),
          const Divider(),
          _widgetTextForModalBottomSheet(
              context,
              "Last Update",
              Funcs().getDateTimeAsText(
                  Funcs().getDateTimeGtoL(widget.note.lastUpdateDate))),
          _widgetTextForModalBottomSheet(
              context,
              "Create Date",
              Funcs().getDateTimeAsText(
                  Funcs().getDateTimeGtoL(widget.note.createdDate))),
          _widgetTextForModalBottomSheet(
              context,
              "Expiration Date",
              Funcs().getDateTimeAsText(
                  Funcs().getDateTimeGtoL(widget.note.expirationDate))),
          const Divider(),
          CustomIconTextButton(
            text: "Edit",
            iconData: Icons.edit,
            onTap: () {
              Navigator.pop(context);
              setState(() {
                isEditing = true;
              });
            },
          ),
          CustomIconTextButton(
            text: "Share",
            iconData: Icons.share,
            onTap: () {
              Navigator.pop(context);
              String textToShare = "*${widget.note.title}*\n\n";

              for (var val in layers
                  .where((element) => element.layerType == LayerType.text)
                  .toList()) {
                textToShare = "$textToShare${val.text}/n";
              }

              textToShare = "$textToShare\n\n\n\nPowered by NoteApp";
              Funcs().shareTextToApps(textToShare);
            },
          ),
        ],
      );
    });
  }

  Widget _widgetTextForModalBottomSheet(context, String text1, String text2) {
    return SimpleUIs.widgetTextForModalBottomSheet(
        context: context, text1: text1, text2: text2);
  }

  void onMoreClicked(context) {
    SimpleUIs.showCustomModalBottomSheet(
      context: context,
      child: _customModalBottomSheet(context),
    );
  }

  void save() async {
    MNote note = widget.note;

    note.title = _tECTitle.text.trim();

    note.lastUpdateDate = Funcs().getGMTDateTimeNow();

    if (shownFolderCounter > 1) {
      await HiveDatabase().editNAFToFolder(note);
    } else {
      await HiveDatabase().ediFirsttNAF(note);
    }

    setState(() {
      isEditing = false;
    });

    for (var element in pathsToDelete) {
      Funcs().deleteFile(element);
    }
  }

  void showMobalBottomSheetForAddLayer() {
    SimpleUIs.showCustomModalBottomSheet(
      context: context,
      child: SimpleUIs.customModalBottomSheetForAddLayer(
        context: context,
        onDone: (value) {
          Provider.of<PLayers>(context).addLayersNoteDetailsPage(value);
        },
      ),
    );
  }
}
