// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donwload_file_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadedFileAdapter extends TypeAdapter<DownloadedFile> {
  @override
  final int typeId = 1;

  @override
  DownloadedFile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadedFile(
      id: fields[0] as String?,
      title: fields[1] as String?,
      description: fields[2] as String?,
      author: fields[3] as String?,
      imageUrl: fields[4] as String?,
      publishedAt: fields[5] as String?,
      fileName: fields[6] as String?,
      filePath: fields[7] as String?,
      fileUrl: fields[8] as String?,
      imagePath: fields[9] as String?,
      pdfLanguage: fields[10] as String?,
      downloadLanguageTranslations:
          (fields[11] as List?)?.cast<DownloadLanguageTranslation>(),
      pdfDocument: fields[12] as bool?,
      audioDocument: fields[13] as bool?,
      videoDocumeent: fields[14] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadedFile obj) {
    writer
      ..writeByte(15)
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
      ..write(obj.publishedAt)
      ..writeByte(6)
      ..write(obj.fileName)
      ..writeByte(7)
      ..write(obj.filePath)
      ..writeByte(8)
      ..write(obj.fileUrl)
      ..writeByte(9)
      ..write(obj.imagePath)
      ..writeByte(10)
      ..write(obj.pdfLanguage)
      ..writeByte(11)
      ..write(obj.downloadLanguageTranslations)
      ..writeByte(12)
      ..write(obj.pdfDocument)
      ..writeByte(13)
      ..write(obj.audioDocument)
      ..writeByte(14)
      ..write(obj.videoDocumeent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadedFileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DownloadLanguageTranslationAdapter
    extends TypeAdapter<DownloadLanguageTranslation> {
  @override
  final int typeId = 2;

  @override
  DownloadLanguageTranslation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadLanguageTranslation(
      language: fields[0] as String,
      id: fields[1] as String,
      link: fields[2] as String,
      filePath: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadLanguageTranslation obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.language)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.link)
      ..writeByte(3)
      ..write(obj.filePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadLanguageTranslationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
