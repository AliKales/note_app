import 'package:flutter/material.dart';
import 'package:note_app/library/hive/hive_database.dart';

class PNotes with ChangeNotifier {
  ///[nAFs] = Notes and Folders
  List nAFs = [];
  String searchText = "";

  Future<bool> addNAF(nAF) async {
    nAFs.insert(0, nAF);

    await HiveDatabase().addFirstNAF(nAF);

    notifyListeners();

    return true;
  }

  void deleteNAF(nAF) async {
    nAFs.remove(nAF);

    await HiveDatabase().deleteFirstNAF(nAF.id!);

    notifyListeners();
  }

  void setNAFs(List list) {
    nAFs = list.reversed.toList();
    notifyListeners();
  }

  void clearNAFs() {
    nAFs.clear();
    notifyListeners();
  }

  void searchByTitle(String text) {
    List listNotes = HiveDatabase().getNAFs;

    if (text != "") {
      nAFs = listNotes.where((element) {
        bool result1 = element.title
                ?.replaceAll(" ", "")
                .contains(text.replaceAll(" ", "")) ??
            false;
        Match? result2 = element.title
            ?.replaceAll(" ", "")
            .toString()
            .matchAsPrefix(text.replaceAll(" ", ""));
        if (result2 != null) {
          return true;
        } else {
          return result1;
        }
      }).toList();
    } else {
      nAFs = listNotes.reversed.toList();
    }

    notifyListeners();
  }
}
