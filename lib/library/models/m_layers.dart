import 'package:hive_flutter/hive_flutter.dart';

part '../hive/hiveModelds/m_layers.g.dart';

///Do not change [layerType]!!!
@HiveType(typeId: 4)
class Layers {
  @HiveField(0)
  String? id;
  @HiveField(1)
  LayerType? layerType;

  Layers({
    this.id,
    this.layerType,
  });
}

@HiveType(typeId: 5)
class LayerText extends Layers {
  @HiveField(2)
  String? text;

  LayerText({
    this.text,
  }) : super(layerType: LayerType.text);
}

@HiveType(typeId: 7)
class LayerImage extends Layers {
  @HiveField(3)
  String? path;

  LayerImage({
    this.path,
  }) : super(layerType: LayerType.image);
}

@HiveType(typeId: 8)
class LayerAudio extends Layers {
  @HiveField(4)
  String? path;

  LayerAudio({this.path}) : super(layerType: LayerType.audio);
}

@HiveType(typeId: 6)
enum LayerType {
  @HiveField(0)
  text,
  @HiveField(1)
  image,
  @HiveField(2)
  audio,
}
