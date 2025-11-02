class SingleResourceResponse {
  final SingleResourceDetails? resource;

  SingleResourceResponse({this.resource});

  factory SingleResourceResponse.fromJson(Map<String, dynamic> json) {
    return SingleResourceResponse(
      resource: json['data']['resource'] != null
          ? SingleResourceDetails.fromJson(json['data']['resource'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'resource': resource?.toJson(),
      },
    };
  }
}

class SingleResourceDetails {
  final String? accessToMaterials;
  final String? author;
  final List<dynamic>? dataType;
  final String? description;
  final String? descriptionDeprecated;
  final String? id;
  final int? order;
  final String? publishingDate;
  final String? slug;
  final String? stage;
  final List<dynamic>? tags;
  final String? title;
  final DateTime? updatedAt;
  final List<SingleResourceDocument>? resourceDocument;
  final List<dynamic>? resourceCategory;
  final ImageDetails? image;
  final List<ToolkitCategory>? toolkitCategories; // New field

  SingleResourceDetails({
    this.accessToMaterials,
    this.author,
    this.dataType,
    this.description,
    this.descriptionDeprecated,
    this.id,
    this.order,
    this.publishingDate,
    this.slug,
    this.stage,
    this.tags,
    this.title,
    this.updatedAt,
    this.resourceDocument,
    this.resourceCategory,
    this.image,
    this.toolkitCategories, // Added to constructor
  });

  factory SingleResourceDetails.fromJson(Map<String, dynamic> json) {
    return SingleResourceDetails(
      accessToMaterials: json['accessToMaterials'],
      author: json['author'],
      dataType: json['dataType'] ?? [],
      description: json['description'],
      descriptionDeprecated: json['descriptionDeprecated'],
      id: json['id'],
      order: json['order'],
      publishingDate: json['publishingDate'],
      slug: json['slug'],
      stage: json['stage'],
      tags: json['tags'] ?? [],
      title: json['title'],
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      resourceDocument: (json['resourceDocument'] as List<dynamic>?)
          ?.map((item) => SingleResourceDocument.fromJson(item))
          .toList(),
      resourceCategory: json['resourceCategory'] ?? [],
      image:
          json['image'] != null ? ImageDetails.fromJson(json['image']) : null,

      toolkitCategories: (json['toolkitCategories'] as List<dynamic>?)
          ?.map((item) => ToolkitCategory.fromJson(item))
          .toList(), // Added parsing
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToMaterials': accessToMaterials,
      'author': author,
      'dataType': dataType,
      'description': description,
      'descriptionDeprecated': descriptionDeprecated,
      'id': id,
      'order': order,
      'publishingDate': publishingDate,
      'slug': slug,
      'stage': stage,
      'tags': tags,
      'title': title,
      'updatedAt': updatedAt?.toIso8601String(),
      'resourceDocument': resourceDocument?.map((doc) => doc.toJson()).toList(),
      'resourceCategory': resourceCategory,
      'image': image?.toJson(),
      'toolkitCategories': toolkitCategories
          ?.map((cat) => cat.toJson())
          .toList(), // Added to JSON
    };
  }
}

// Add this new class for toolkit categories
class ToolkitCategory {
  final String? id;

  ToolkitCategory({this.id});

  factory ToolkitCategory.fromJson(Map<String, dynamic> json) {
    return ToolkitCategory(
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}

// Rest of the classes remain the same
class SingleResourceDocument {
  final String? id;
  final String? link;
  final String? title;
  final List<ResourceTranslation>? resourceTranslations;
  final String? fileFormat;

  SingleResourceDocument({
    this.id,
    this.link,
    this.title,
    this.resourceTranslations,
    this.fileFormat,
  });

  factory SingleResourceDocument.fromJson(Map<String, dynamic> json) {
    return SingleResourceDocument(
      id: json['id'],
      link: json['link'],
      title: json['title'],
      resourceTranslations: (json['resourceTranslations'] as List<dynamic>?)
          ?.map((item) => ResourceTranslation.fromJson(item))
          .toList(),
      fileFormat: json['fileFormat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'link': link,
      'title': title,
      'resourceTranslations':
          resourceTranslations?.map((trans) => trans.toJson()).toList(),
      'fileFormat': fileFormat,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

class ResourceTranslation {
  final String? language;
  final String? id;
  final String? link;

  ResourceTranslation({
    this.language,
    this.id,
    this.link,
  });

  factory ResourceTranslation.fromJson(Map<String, dynamic> json) {
    return ResourceTranslation(
      language: json['language'],
      id: json['id'],
      link: json['link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'id': id,
      'link': link,
    };
  }
}

class ImageDetails {
  final String? id;
  final String? url;

  ImageDetails({this.id, this.url});

  factory ImageDetails.fromJson(Map<String, dynamic> json) {
    return ImageDetails(
      id: json['id'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
    };
  }
}
