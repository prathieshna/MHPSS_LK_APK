import 'package:beprepared/features/data/models/responses/toolkit_categories_response.dart';

class ToolkitSubCategoryResponse {
  final ToolkitData? data;

  ToolkitSubCategoryResponse({this.data});

  factory ToolkitSubCategoryResponse.fromJson(Map<String, dynamic> json) {
    return ToolkitSubCategoryResponse(
      data: json['data'] != null ? ToolkitData.fromJson(json['data']) : null,
    );
  }
}

class ToolkitData {
  final Toolkit? toolkit;

  ToolkitData({this.toolkit});

  factory ToolkitData.fromJson(Map<String, dynamic> json) {
    return ToolkitData(
      toolkit:
          json['toolkit'] != null ? Toolkit.fromJson(json['toolkit']) : null,
    );
  }
}

class Toolkit {
  final List<ToolkitCategory?>? toolkitCategories;

  Toolkit({this.toolkitCategories});

  factory Toolkit.fromJson(Map<String, dynamic> json) {
    return Toolkit(
      toolkitCategories: json['toolkitCategories'] != null
          ? (json['toolkitCategories'] as List)
              .map((e) => e != null ? ToolkitCategory.fromJson(e) : null)
              .toList()
          : null,
    );
  }
}

class ToolkitCategory {
  final String? id;
  final String? title;
  final String? slug;
  final ToolkitImage? image;
  final List<ToolkitAllCategory>? toolkitSubCategories;

  ToolkitCategory(
      {this.id, this.title, this.slug, this.image, this.toolkitSubCategories});

  factory ToolkitCategory.fromJson(Map<String, dynamic> json) {
    return ToolkitCategory(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      image:
          json['image'] != null ? ToolkitImage.fromJson(json['image']) : null,
      toolkitSubCategories: (json['toolkitSubCategories'] as List<dynamic>?)
          ?.map((e) => ToolkitAllCategory.fromJson(e))
          .toList(),
    );
  }
}
