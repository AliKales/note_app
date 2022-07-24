import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_app/library/models/m_folder.dart';

part 'hive/hiveModelds/values.g.dart';

const cBackgroundColor = Color.fromARGB(255, 241, 241, 241);
const cGradientColor1 = Color(0xFFD8ECFF);
const cGradientColor2 = Color(0xFFF0EAFD);
const cFolderColor = Color.fromARGB(255, 247, 186, 18);
const cButtomNavBarColor = Color.fromARGB(255, 35, 153, 163);
const cAudioPlayerBackgroundColor = Color.fromARGB(255, 53, 51, 64);

const cRadius = 14.0;
const cPaddingPage = 13.0;

const List<Color> colors = [
  Color(0xFF4FA3A5),
  Color(0xFF7D50B9),
  Color(0xFFFA5396),
  Color(0xFF3A3E59),
  Color(0xFFED5B6B),
];

@HiveType(typeId: 2)
enum ItemType {
  @HiveField(0)
  note,
  @HiveField(1)
  folder,
}

MFolder? selectedFolderForNote;

int shownFolderCounter = 0;

String pathToAppFolder="/storage/emulated/0/Android/media/com.caroby.noteapp/NoteApp";

const String appName = "Note App";

String? appPassword;
