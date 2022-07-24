import 'package:hive/hive.dart';
import 'package:note_app/library/values.dart';

part '../hive/hiveModelds/m_folder.g.dart';

@HiveType(typeId: 3)
class MFolder {
  @HiveField(0)
  String? title;
  @HiveField(1)
  String? description;
  @HiveField(2)
  String? password;
  @HiveField(3)
  DateTime? createdDate;
  @HiveField(4)
  DateTime? lastUpdateDate;
  @HiveField(5)
  DateTime? expirationDate;
  @HiveField(6)
  String? id;
  @HiveField(7)
  ItemType? itemType;
  @HiveField(8)
  List<String>? nAFIds;

  MFolder({
    this.title,
    this.description,
    this.createdDate,
    this.expirationDate,
    this.password,
    this.id,
    this.itemType,
    this.lastUpdateDate,
    this.nAFIds,
  });
}
