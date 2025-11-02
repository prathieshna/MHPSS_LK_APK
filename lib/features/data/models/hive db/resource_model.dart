import 'package:hive/hive.dart';

part 'resource_model.g.dart';

@HiveType(typeId: 0)
class ResourceModel {
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
  bool? isFavorite;

  @HiveField(6)
  final String? downloadUrl;

  @HiveField(7)
  final List<String>? languagesList;

  @HiveField(8)
  final List<String>? fileTypeList;

  @HiveField(9)
  final List<String>? toolkitCategories;

  @HiveField(10)
  final bool? pdfDocument;

  @HiveField(11)
  final bool? audioDocument;

  @HiveField(12)
  final bool? videoDocumeent;

  ResourceModel(
      {this.id,
      this.title,
      this.description,
      this.author,
      this.imageUrl,
      this.isFavorite = false,
      this.downloadUrl,
      this.languagesList,
      this.fileTypeList,
      this.toolkitCategories,
      this.pdfDocument,
      this.audioDocument,
      this.videoDocumeent});
}

// flutter packages pub run build_runner build  --delete-conflicting-outputs
