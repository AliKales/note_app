// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../models/m_note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MNoteAdapter extends TypeAdapter<MNote> {
  @override
  final int typeId = 1;

  @override
  MNote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MNote(
      title: fields[0] as String?,
      createdDate: fields[1] as DateTime?,
      expirationDate: fields[2] as DateTime?,
      password: fields[3] as String?,
      id: fields[4] as String?,
      itemType: fields[5] as ItemType?,
      layers: (fields[7] as List?)?.cast<dynamic>(),
      lastUpdateDate: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MNote obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.createdDate)
      ..writeByte(2)
      ..write(obj.expirationDate)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.itemType)
      ..writeByte(6)
      ..write(obj.lastUpdateDate)
      ..writeByte(7)
      ..write(obj.layers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MNoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
