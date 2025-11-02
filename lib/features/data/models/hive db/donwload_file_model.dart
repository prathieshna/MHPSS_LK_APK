import 'package:hive_flutter/hive_flutter.dart';

part 'donwload_file_model.g.dart';

@HiveType(typeId: 1)
class DownloadedFile {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final String? author;

  @HiveField(4)
  final String? imageUrl;

  @HiveField(5)
  final String? publishedAt;

  @HiveField(6)
  final String? fileName;

  @HiveField(7)
  final String? filePath;

  @HiveField(8)
  final String? fileUrl;

  @HiveField(9)
  final String? imagePath;

  @HiveField(10)
  final String? pdfLanguage;

  @HiveField(11)
  final List<DownloadLanguageTranslation>? downloadLanguageTranslations;

  @HiveField(12)
  final bool? pdfDocument;

  @HiveField(13)
  final bool? audioDocument;

  @HiveField(14)
  final bool? videoDocumeent;

  DownloadedFile(
      {this.id,
      this.title,
      this.description,
      this.author,
      this.imageUrl,
      this.publishedAt,
      this.fileName,
      this.filePath,
      this.fileUrl,
      this.imagePath,
      this.pdfLanguage,
      this.downloadLanguageTranslations,
      this.pdfDocument,
      this.audioDocument,
      this.videoDocumeent});

  factory DownloadedFile.fromJson(Map<String, dynamic> json) => DownloadedFile(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      author: json['author'],
      imageUrl: json['imageUrl'],
      publishedAt: json['publishedAt'],
      fileName: json['fileName'],
      filePath: json['filePath'],
      fileUrl: json['fileUrl'],
      imagePath: json['imagePath'],
      pdfLanguage: json['pdfLanguage'],
      downloadLanguageTranslations:
          (json['resourceTranslations'] as List<dynamic>?)
              ?.map((item) => DownloadLanguageTranslation.fromJson(item))
              .toList(),
      pdfDocument: json['pdfDocument'],
      audioDocument: json['audioDocument'],
      videoDocumeent: json['videoDocumeent']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'author': author,
        'imageUrl': imageUrl,
        'publishedAt': publishedAt,
        'fileName': fileName,
        'filePath': filePath,
        'fileUrl': fileUrl,
        'imagePath': imagePath,
        'pdfLanguage': pdfLanguage,
        'resourceTranslations': downloadLanguageTranslations
            ?.map((trans) => trans.toJson())
            .toList(),
        'pdfDocument': pdfDocument,
        'audioDocument': audioDocument,
        'videoDocumeent': videoDocumeent
      };

  @override
  String toString() {
    return toJson().toString();
  }
}

@HiveType(typeId: 2)
class DownloadLanguageTranslation {
  @HiveField(0)
  final String language;

  @HiveField(1)
  final String id;

  @HiveField(2)
  final String link;

  @HiveField(3)
  final String? filePath;

  DownloadLanguageTranslation({
    required this.language,
    required this.id,
    required this.link,
    this.filePath,
  });

  factory DownloadLanguageTranslation.fromJson(Map<String, dynamic> json) {
    return DownloadLanguageTranslation(
      language: json['language'],
      id: json['id'],
      link: json['link'],
      filePath: json['filePath'],
    );
  }

  Map<String, dynamic> toJson() => {
        'language': language,
        'id': id,
        'link': link,
        'filePath': filePath,
      };
}
