import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ShowImagePage extends StatelessWidget {
  const ShowImagePage({Key? key, required this.file}) : super(key: key);

  final File file;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PhotoView(
        imageProvider: FileImage(file),
      ),
    );
  }
}
