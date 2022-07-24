import 'package:hive/hive.dart';
import 'package:note_app/library/models/m_folder.dart';
import 'package:note_app/library/values.dart';

class HiveDatabase {
  var boxFirstNAFs = Hive.box("firstNAFs");
  var boxNAFs = Hive.box("NAFs");
  var database = Hive.box("database");

  dynamic get getNAFs => boxFirstNAFs.values.toList();

  Future<dynamic> getValueFromDB(String key) async {
    return await database.get(key);
  }

  Future<dynamic> putValueToDB(String key, dynamic value) async {
    return await database.put(key, value);
  }

  Future addFirstNAF(dynamic nAF) async {
    int id = await boxFirstNAFs.add(nAF);
    nAF.id = id.toString();
    await boxFirstNAFs.put(id, nAF);
  }

  Future deleteFirstNAF(String id) async {
    await boxFirstNAFs.delete(int.parse(id));
  }

  Future ediFirsttNAF(dynamic nAF) async {
    //here we parse id to int because if it's not int then it wont find what we look for
    await boxFirstNAFs.put(int.parse(nAF.id), nAF);
  }

  Future<bool> addNAFToFolder(nAF, MFolder folder) async {
    //here it puts note to database
    int id = await boxNAFs.add(nAF);
    nAF.id = id;
    await boxNAFs.put(id, nAF);
    //here it puts id of note to folder
    folder.nAFIds ??= [];

    folder.nAFIds!.insert(0, nAF.id!);

    if (shownFolderCounter > 1) {
      await editNAFToFolder(folder);
    } else {
      await ediFirsttNAF(folder);
    }
    return true;
  }

  Future editNAFToFolder(dynamic nAF) async {
    await boxNAFs.put(nAF.id, nAF);
  }

  List getTitles(List<String> ids) {
    List notes = [];

    for (var id in ids) {
      notes.add(boxNAFs.get(id));
    }

    return notes;
  }

  Future clearAllNotes() async {
    await boxFirstNAFs.clear();
    await boxNAFs.clear();
  }
}
