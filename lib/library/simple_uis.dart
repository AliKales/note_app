import 'dart:io';

import 'package:flutter/material.dart';
import 'package:note_app/library/UIs/custom_button.dart';
import 'package:note_app/library/UIs/custom_icon_text_button.dart';
import 'package:note_app/library/UIs/custom_textfield.dart';
import 'package:note_app/library/funcs.dart';
import 'package:note_app/library/models/m_layers.dart';
import 'package:note_app/library/provider/p_audio_player.dart';
import 'package:note_app/library/values.dart';
import 'package:note_app/pages/show_image_page.dart';
import 'package:provider/provider.dart';

class SimpleUIs {
  static Widget widgetTextForModalBottomSheet(
      {required context, String? text1, String? text2}) {
    return Text.rich(
      TextSpan(children: [
        TextSpan(
            text: "$text1: ",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.w600)),
        TextSpan(text: text2, style: Theme.of(context).textTheme.headline6)
      ]),
    );
  }

  static IconButton customAppbarBackButton(
      {required context, Function()? onTap}) {
    if (onTap == null) {
      return IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.black,
          ));
    } else {
      return IconButton(
        onPressed: () => onTap.call(),
        icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
      );
    }
  }

  static void showCustomModalBottomSheet({
    required context,
    required Widget child,
  }) {
    showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      context: context,
      backgroundColor: cBackgroundColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(cRadius))),
      builder: (_) {
        return NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.6,
              builder: (context, controller) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 173, 173, 173),
                          borderRadius: BorderRadius.all(
                            Radius.circular(cRadius),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: controller,
                          child: child,
                        ),
                      ),
                    ],
                  ),
                );
              }),
        );
      },
    );
  }

  static Future<String?> showTextInput(
      {required context,
      required String label,
      required String buttonText}) async {
    TextEditingController tEC = TextEditingController();
    String? text;
    await showGeneralDialog(
        barrierLabel: "Barrier",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 500),
        context: context,
        pageBuilder: (_, __, ___) {
          return SizedBox(
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: const BoxDecoration(
                    color: cBackgroundColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(cRadius),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width / 1.15,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextField(
                        label: label,
                        textEditingController: tEC,
                      ),
                      CustomButton(
                        text: buttonText,
                        onTap: () {
                          text = tEC.text.trim();
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
    print(text);
    return text;
  }

  static Future<bool> showDialogYesNo({required context, String? text}) async {
    bool boolReturn = false;

    FocusScope.of(context).unfocus();
    await showGeneralDialog(
        barrierLabel: "Barrier",
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 500),
        context: context,
        pageBuilder: (_, __, ___) {
          return SizedBox(
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: const BoxDecoration(
                    color: cBackgroundColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(cRadius),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(text ?? "Are you sure?",
                          style: Theme.of(context).textTheme.headline6!),
                      CustomButton(
                        text: "No",
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      CustomButton.outlined(
                        textOutlined: "Yes",
                        onTap: () {
                          boolReturn = true;
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });

    return boolReturn;
  }

  Widget sizedBoxAsBottomNavBar() {
    return const SizedBox(
      height: kBottomNavigationBarHeight * 2,
    );
  }

  static Widget customModalBottomSheetForAddLayer(
      {required context, required Function(dynamic) onDone}) {
    return Column(
      children: [
        CustomIconTextButton(
          text: "Text",
          iconData: Icons.text_fields,
          onTap: () {
            Navigator.pop(context);
            LayerText layerText = LayerText();
            layerText.id = Funcs().getId();
            onDone.call(layerText);
          },
        ),
        CustomIconTextButton(
          text: "Image From Gallery",
          iconData: Icons.image,
          onTap: () async {
            String? path = await Funcs.getImage(context, false);
            if (path == null) return;

            LayerImage layerImage = LayerImage();
            layerImage.path = path;
            layerImage.id = Funcs().getId();
            Navigator.pop(context);
            onDone.call(layerImage);
          },
        ),
        CustomIconTextButton(
          text: "Camera",
          iconData: Icons.camera_alt,
          onTap: () async {
            String? path = await Funcs.getImage(context, true);
            if (path == null) return;

            LayerImage layerImage = LayerImage();
            layerImage.path = path;
            layerImage.id = Funcs().getId();
            Navigator.pop(context);
            onDone.call(layerImage);
          },
        ),
        CustomIconTextButton(
          text: "Audio",
          iconData: Icons.mic,
          onTap: () {
            Navigator.pop(context);
            Provider.of<PAudioPlayer>(context, listen: false).startRecord();
          },
        ),
      ],
    );
  }

  static Widget biggerImageOnClick(
      {required context, required Widget widget, required File file}) {
    return InkWell(
        onTap: () {
          Funcs().navigatorPush(context, ShowImagePage(file: file));
        },
        child: widget);
  }

  Future showProgressIndicator(context) async {
    FocusScope.of(context).unfocus();
    if (ModalRoute.of(context)?.isCurrent ?? true) {
      await showGeneralDialog(
          barrierLabel: "Barrier",
          barrierDismissible: false,
          barrierColor: Colors.black.withOpacity(0.5),
          transitionDuration: const Duration(milliseconds: 500),
          context: context,
          pageBuilder: (_, __, ___) {
            return WillPopScope(
              onWillPop: () async => false,
              child: const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          });
    }
  }
}
