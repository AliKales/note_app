import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_app/library/funcs.dart';
import 'package:note_app/library/values.dart';

part '../hive/hiveModelds/m_note.g.dart';

@HiveType(typeId: 1)
class MNote {
  @HiveField(0)
  String? title;
  @HiveField(1)
  DateTime? createdDate;
  @HiveField(2)
  DateTime? expirationDate;
  @HiveField(3)
  String? password;
  @HiveField(4)
  String? id;
  @HiveField(5)
  ItemType? itemType;
  @HiveField(6)
  DateTime? lastUpdateDate;
  @HiveField(7)
  List? layers;

  MNote(
      {this.title,
      this.createdDate,
      this.expirationDate,
      this.password,
      this.itemType,
      this.id,
      this.layers,
      this.lastUpdateDate});
}
