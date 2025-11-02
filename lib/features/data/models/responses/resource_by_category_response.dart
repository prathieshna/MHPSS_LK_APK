class ResourceByCategoryResponse {
  final ResourceByCategoryData data;

  ResourceByCategoryResponse({required this.data});

  factory ResourceByCategoryResponse.fromJson(Map<String, dynamic> json) {
    return ResourceByCategoryResponse(
      data: ResourceByCategoryData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
    };
  }
}

class ResourceByCategoryData {
  final Toolkit toolkit;

  ResourceByCategoryData({required this.toolkit});

  factory ResourceByCategoryData.fromJson(Map<String, dynamic> json) {
    return ResourceByCategoryData(
      toolkit: Toolkit.fromJson(json['toolkit'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'toolkit': toolkit.toJson(),
    };
  }
}

class Toolkit {
  final List<ToolkitCategory> toolkitCategories;

  Toolkit({required this.toolkitCategories});

  factory Toolkit.fromJson(Map<String, dynamic> json) {
    var list = json['toolkitCategories'] as List? ?? [];
    return Toolkit(
      toolkitCategories:
          list.map((i) => ToolkitCategory.fromJson(i ?? {})).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'toolkitCategories': toolkitCategories.map((e) => e.toJson()).toList(),
    };
  }
}

class ToolkitCategory {
  final List<Resource> resources;
  final String? title;
  final String? id;

  ToolkitCategory({
    required this.resources,
    this.title,
    this.id,
  });

  factory ToolkitCategory.fromJson(Map<String, dynamic> json) {
    var resourceList = json['resource'] as List? ?? [];
    return ToolkitCategory(
      resources: resourceList.map((i) => Resource.fromJson(i ?? {})).toList(),
      title: json['title']?.toString(),
      id: json['id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resource': resources.map((e) => e.toJson()).toList(),
      'title': title,
      'id': id,
    };
  }
}

class Resource {
  final String id;
  final Image image;
  final String title;
  final String slug;
  final int? publishingDate;
  final dynamic publishedAt;
  final String createdAt;
  final String author;
  final dynamic descriptionDeprecated;
  final List<ResourceDocument> resourceDocument;

  Resource({
    required this.id,
    required this.image,
    required this.title,
    required this.slug,
    this.publishingDate,
    this.publishedAt,
    required this.createdAt,
    required this.author,
    this.descriptionDeprecated,
    required this.resourceDocument,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      id: json['id']?.toString() ?? '',
      image: Image.fromJson(json['image'] ?? {}),
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      publishingDate: _parsePublishingDate(json['publishingDate']),
      publishedAt: json['publishedAt'],
      createdAt: json['createdAt']?.toString() ?? '',
      author: json['author']?.toString() ?? '',
      descriptionDeprecated: json['descriptionDeprecated'],
      resourceDocument: _parseResourceDocuments(json['resourceDocument']),
    );
  }

  static int? _parsePublishingDate(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static List<ResourceDocument> _parseResourceDocuments(dynamic value) {
    if (value is! List) return [];
    return value.map((doc) => ResourceDocument.fromJson(doc ?? {})).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image.toJson(),
      'title': title,
      'slug': slug,
      'publishingDate': publishingDate,
      'publishedAt': publishedAt,
      'createdAt': createdAt,
      'author': author,
      'descriptionDeprecated': descriptionDeprecated,
      'resourceDocument': resourceDocument.map((e) => e.toJson()).toList(),
    };
  }
}

class Image {
  final String url;

  Image({required this.url});

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      url: json['url']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }
}

class ResourceDocument {
  final List<ResourceTranslation> resourceTranslations;
  final String? fileFormat;

  ResourceDocument({
    required this.resourceTranslations,
    this.fileFormat,
  });

  factory ResourceDocument.fromJson(Map<String, dynamic> json) {
    return ResourceDocument(
      resourceTranslations:
          _parseResourceTranslations(json['resourceTranslations']),
      fileFormat: json['fileFormat']?.toString(),
    );
  }

  static List<ResourceTranslation> _parseResourceTranslations(dynamic value) {
    if (value is! List) return [];
    return value
        .map((trans) => ResourceTranslation.fromJson(trans ?? {}))
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'resourceTranslations':
          resourceTranslations.map((e) => e.toJson()).toList(),
      'fileFormat': fileFormat,
    };
  }
}

class ResourceTranslation {
  final String id;
  final String? language;

  ResourceTranslation({required this.id, this.language});

  factory ResourceTranslation.fromJson(Map<String, dynamic> json) {
    return ResourceTranslation(
      id: json['id']?.toString() ?? '',
      language: json['language']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'language': language,
    };
  }
}
