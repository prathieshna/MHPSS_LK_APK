// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResourceModelAdapter extends TypeAdapter<ResourceModel> {
  @override
  final int typeId = 0;

  @override
  ResourceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ResourceModel(
      id: fields[0] as String?,
      title: fields[1] as String?,
      description: fields[2] as String?,
      author: fields[3] as String?,
      imageUrl: fields[4] as String?,
      isFavorite: fields[5] as bool?,
      downloadUrl: fields[6] as String?,
      languagesList: (fields[7] as List?)?.cast<String>(),
      fileTypeList: (fields[8] as List?)?.cast<String>(),
      toolkitCategories: (fields[9] as List?)?.cast<String>(),
      pdfDocument: fields[10] as bool?,
      audioDocument: fields[11] as bool?,
      videoDocumeent: fields[12] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, ResourceModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.author)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.isFavorite)
      ..writeByte(6)
      ..write(obj.downloadUrl)
      ..writeByte(7)
      ..write(obj.languagesList)
      ..writeByte(8)
      ..write(obj.fileTypeList)
      ..writeByte(9)
      ..write(obj.toolkitCategories)
      ..writeByte(10)
      ..write(obj.pdfDocument)
      ..writeByte(11)
      ..write(obj.audioDocument)
      ..writeByte(12)
      ..write(obj.videoDocumeent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResourceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
