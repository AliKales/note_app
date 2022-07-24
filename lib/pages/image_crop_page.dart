import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:note_app/library/values.dart';

class ImageCropPage extends StatelessWidget {
  ImageCropPage({Key? key, required this.path}) : super(key: key);

  final String path;
  GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: cBackgroundColor,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context, editorKey.currentState!.rawImageData);
            },
            icon: const Icon(
              Icons.check,
              color: Colors.green,
            ),
          ),
        ],
        title: const Text(
          "Crop Image",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.3,
      ),
      bottomNavigationBar: SizedBox(
        height: kBottomNavigationBarHeight,
        child: Row(
          children: [
            _widgetBottomIcon(() => onTap(0), Icons.refresh, "Resert"),
            _widgetBottomIcon(() => onTap(1), Icons.flip, "Flip"),
            _widgetBottomIcon(() => onTap(2), Icons.rotate_left, "Rotate L"),
            _widgetBottomIcon(() => onTap(3), Icons.rotate_right, "Rotate R"),
          ],
        ),
      ),
      body: ExtendedImage.file(
        File(path),
        cacheRawData: true,
        fit: BoxFit.contain,
        mode: ExtendedImageMode.editor,
        extendedImageEditorKey: editorKey,
        initEditorConfigHandler: (state) {
          return EditorConfig(
            cropRectPadding: const EdgeInsets.all(20.0),
          );
        },
      ),
    );
  }

  Widget _widgetBottomIcon(
      VoidCallback onTap, IconData iconData, String label) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconData),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }

  void onTap(int value) {
    if (value == 0) editorKey.currentState!.reset();
    if (value == 1) editorKey.currentState!.flip();
    if (value == 2) editorKey.currentState!.rotate(right: false);
    if (value == 3) editorKey.currentState!.rotate(right: true);
  }
}
