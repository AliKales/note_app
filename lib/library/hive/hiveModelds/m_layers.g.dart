// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../models/m_layers.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LayersAdapter extends TypeAdapter<Layers> {
  @override
  final int typeId = 4;

  @override
  Layers read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Layers(
      id: fields[0] as String?,
      layerType: fields[1] as LayerType?,
    );
  }

  @override
  void write(BinaryWriter writer, Layers obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.layerType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LayersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LayerTextAdapter extends TypeAdapter<LayerText> {
  @override
  final int typeId = 5;

  @override
  LayerText read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LayerText(
      text: fields[2] as String?,
    )
      ..id = fields[0] as String?
      ..layerType = fields[1] as LayerType?;
  }

  @override
  void write(BinaryWriter writer, LayerText obj) {
    writer
      ..writeByte(3)
      ..writeByte(2)
      ..write(obj.text)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.layerType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LayerTextAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LayerImageAdapter extends TypeAdapter<LayerImage> {
  @override
  final int typeId = 7;

  @override
  LayerImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LayerImage(
      path: fields[3] as String?,
    )
      ..id = fields[0] as String?
      ..layerType = fields[1] as LayerType?;
  }

  @override
  void write(BinaryWriter writer, LayerImage obj) {
    writer
      ..writeByte(3)
      ..writeByte(3)
      ..write(obj.path)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.layerType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LayerImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LayerAudioAdapter extends TypeAdapter<LayerAudio> {
  @override
  final int typeId = 8;

  @override
  LayerAudio read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LayerAudio(
      path: fields[4] as String?,
    )
      ..id = fields[0] as String?
      ..layerType = fields[1] as LayerType?;
  }

  @override
  void write(BinaryWriter writer, LayerAudio obj) {
    writer
      ..writeByte(3)
      ..writeByte(4)
      ..write(obj.path)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.layerType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LayerAudioAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LayerTypeAdapter extends TypeAdapter<LayerType> {
  @override
  final int typeId = 6;

  @override
  LayerType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LayerType.text;
      case 1:
        return LayerType.image;
      case 2:
        return LayerType.audio;
      default:
        return LayerType.text;
    }
  }

  @override
  void write(BinaryWriter writer, LayerType obj) {
    switch (obj) {
      case LayerType.text:
        writer.writeByte(0);
        break;
      case LayerType.image:
        writer.writeByte(1);
        break;
      case LayerType.audio:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LayerTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
