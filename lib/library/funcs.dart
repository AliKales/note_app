import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/library/hive/hive_database.dart';
import 'package:note_app/library/values.dart';
import 'package:note_app/pages/image_crop_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import 'simple_uis.dart';

class Funcs {
  Future<dynamic> navigatorPush(context, page) async {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => page);
    var object = await Navigator.push(context, route);
    return object;
  }

  void navigatorPushReplacement(context, page) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => page);
    Navigator.pushReplacement(context, route);
  }

  ///[getDateTimeGtoL] is getting global date time
  DateTime getGMTDateTimeNow() {
    int iS = DateTime.now().timeZoneOffset.inMinutes;
    return DateTime.now().subtract(Duration(minutes: iS));
  }

  ///[getDateTimeLtoG] is converting a local DateTime to global DateTime
  DateTime? getDateTimeLtoG(DateTime? dt) {
    int iS = DateTime.now().timeZoneOffset.inMinutes;
    return dt?.subtract(Duration(minutes: iS));
  }

  ///[getDateTimeGtoL] is coverting a global DateTime to local time
  DateTime? getDateTimeGtoL(DateTime? dT) {
    int iS = DateTime.now().timeZoneOffset.inMinutes;
    return dT?.add(Duration(minutes: iS));
  }

  String getDateTimeAsText(DateTime? dT) =>
      dT == null ? "---" : "${dT.day}/${dT.month}/${dT.year}";

  static Color? color;
  Color getRandomColor() {
    List<Color> listColors = colors.toList();

    int length = color == null ? listColors.length : listColors.length - 1;
    if (color != null) listColors.remove(color);

    color = listColors[Random().nextInt(length)];

    return color!;
  }

  void showSnackBar(context, String text) {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: const TextStyle(color: Colors.black),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: cGradientColor1,
      ),
    );
  }

  DateTime dateTimeZeroHourMin(DateTime dT) {
    return DateTime(dT.year, dT.month, dT.day);
  }

  ///[checkExpiration] returns true if this note is NOT available anymore
  bool checkExpiration(DateTime? dTNote) {
    if (dTNote == null) return false;

    DateTime dT = Funcs().getGMTDateTimeNow();
    dT = Funcs().dateTimeZeroHourMin(dT);

    DateTime noteDateTime = Funcs().dateTimeZeroHourMin(dTNote);
    return noteDateTime.isBefore(dT) || noteDateTime.isAtSameMomentAs(dT);
  }

  void shareTextToApps(String text) {
    Share.share(text);
  }

  String getId() {
    DateTime dt = getGMTDateTimeNow();
    return "${dt.year}${dt.month}${dt.day}${dt.hour}${dt.minute}${dt.second}${dt.millisecond}";
  }

  Future<bool> checkPermissions([List<Permission>? permissions]) async {
    if (permissions == null) return true;
    Map<Permission, PermissionStatus> statuses = await permissions.request();

    if (statuses.values.toList().contains(PermissionStatus.denied)) {
      return false;
    }
    return true;
  }

  static Future<String?> getImage(context, bool isCamera) async {
    if (!await Funcs()
        .checkPermissions([Permission.storage, Permission.camera])) return null;

    final ImagePicker picker = ImagePicker();
    // Pick an image
    XFile? image;

    if (isCamera) {
      image = await picker.pickImage(source: ImageSource.camera);
    } else {
      image = await picker.pickImage(source: ImageSource.gallery);
    }

    if (image == null) return null;

    String path = "$pathToAppFolder/images/${image.path.split("/").last}";

    if (await SimpleUIs.showDialogYesNo(
        context: context, text: "Do you want to crop the image?")) {
      Uint8List? bytes =
          await Funcs().navigatorPush(context, ImageCropPage(path: image.path));
      if (bytes != null) image = XFile.fromData(bytes);
    }

    image.saveTo(path);

    return path;
  }

  void unFocus(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  Future createFolders() async {
    String audios = "$pathToAppFolder/audios/";
    if (!await Directory(audios).exists()) {
      await Directory(audios).create(recursive: true);
    }

    String images = "$pathToAppFolder/images/";

    if (!await Directory(images).exists()) {
      await Directory(images).create(recursive: true);
    }
  }

  void deleteFile(String path) async {
    // Directory(path).deleteSync();
    print("object");
    File(path).deleteSync();
  }

  Future clearAllNotes() async {
    await HiveDatabase().clearAllNotes();

    await Directory("$pathToAppFolder/images/").delete(recursive: true);
    await Directory("$pathToAppFolder/audios/").delete(recursive: true);

    await createFolders();
    return;
  }

  Future<String> getAppDocPath() async {
    Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
