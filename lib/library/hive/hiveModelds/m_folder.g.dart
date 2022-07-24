// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../models/m_folder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MFolderAdapter extends TypeAdapter<MFolder> {
  @override
  final int typeId = 3;

  @override
  MFolder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MFolder(
      title: fields[0] as String?,
      description: fields[1] as String?,
      createdDate: fields[3] as DateTime?,
      expirationDate: fields[5] as DateTime?,
      password: fields[2] as String?,
      id: fields[6] as String?,
      itemType: fields[7] as ItemType?,
      lastUpdateDate: fields[4] as DateTime?,
      nAFIds: (fields[8] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, MFolder obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.createdDate)
      ..writeByte(4)
      ..write(obj.lastUpdateDate)
      ..writeByte(5)
      ..write(obj.expirationDate)
      ..writeByte(6)
      ..write(obj.id)
      ..writeByte(7)
      ..write(obj.itemType)
      ..writeByte(8)
      ..write(obj.nAFIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MFolderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
