class PopularResourcesResponse {
  Data? data;

  PopularResourcesResponse({this.data});

  factory PopularResourcesResponse.fromJson(Map<String, dynamic> json) {
    return PopularResourcesResponse(
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }
}

class Data {
  Toolkit? toolkit;

  Data({this.toolkit});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      toolkit:
          json['toolkit'] != null ? Toolkit.fromJson(json['toolkit']) : null,
    );
  }
}

class Toolkit {
  String? description;
  String? hostMessage;
  String? id;
  String? title;
  List<PopularResource>? resources;

  Toolkit(
      {this.description,
      this.hostMessage,
      this.id,
      this.title,
      this.resources});

  factory Toolkit.fromJson(Map<String, dynamic> json) {
    var resourceList = json['resources'] as List?;
    List<PopularResource>? resources =
        resourceList?.map((i) => PopularResource.fromJson(i)).toList();

    return Toolkit(
      description: json['description'],
      hostMessage: json['hostMessage'],
      id: json['id'],
      title: json['title'],
      resources: resources,
    );
  }
}

class PopularResource {
  String? id;
  ImageUrl? image;
  String? title;
  String? slug;
  String? publishingDate;
  String? publishedAt;
  String? createdAt;
  String? author;
  String? descriptionDeprecated;
  List<PopularResourceDocument>? resourceDocument;
  List<ToolkitCategory>? toolkitCategories;
  bool? popular;

  PopularResource({
    this.id,
    this.image,
    this.title,
    this.slug,
    this.publishingDate,
    this.publishedAt,
    this.createdAt,
    this.author,
    this.descriptionDeprecated,
    this.resourceDocument,
    this.toolkitCategories,
    this.popular,
  });

  factory PopularResource.fromJson(Map<String, dynamic> json) {
    var documentList = json['resourceDocument'] as List?;
    List<PopularResourceDocument>? resourceDocuments =
        documentList?.map((i) => PopularResourceDocument.fromJson(i)).toList();

    var categoryList = json['toolkitCategories'] as List?;
    List<ToolkitCategory>? categories =
        categoryList?.map((i) => ToolkitCategory.fromJson(i)).toList();

    return PopularResource(
      id: json['id'],
      image: json['image'] != null ? ImageUrl.fromJson(json['image']) : null,
      title: json['title'],
      slug: json['slug'],
      publishingDate: json['publishingDate'],
      publishedAt: json['publishedAt'],
      createdAt: json['createdAt'],
      author: json['author'],
      descriptionDeprecated: json['descriptionDeprecated'],
      resourceDocument: resourceDocuments,
      toolkitCategories: categories,
      popular: json['popular'],
    );
  }
}

class ImageUrl {
  String? url;

  ImageUrl({this.url});

  factory ImageUrl.fromJson(Map<String, dynamic> json) {
    return ImageUrl(
      url: json['url'],
    );
  }
}

class PopularResourceDocument {
  List<PopularResourceTranslation>? resourceTranslations;
  String? fileFormat;

  PopularResourceDocument({this.resourceTranslations, this.fileFormat});

  factory PopularResourceDocument.fromJson(Map<String, dynamic> json) {
    var translationList = json['resourceTranslations'] as List?;
    List<PopularResourceTranslation>? translations = translationList
        ?.map((i) => PopularResourceTranslation.fromJson(i))
        .toList();

    return PopularResourceDocument(
      resourceTranslations: translations,
      fileFormat: json['fileFormat'],
    );
  }
}

class PopularResourceTranslation {
  String? id;
  String? language;

  PopularResourceTranslation({this.id, this.language});

  factory PopularResourceTranslation.fromJson(Map<String, dynamic> json) {
    return PopularResourceTranslation(
      id: json['id'],
      language: json['language'],
    );
  }
}

class ToolkitCategory {
  String? id;
  String? longTitle;
  String? slug;
  List<String>? tags;
  String? title;

  ToolkitCategory({this.id, this.longTitle, this.slug, this.tags, this.title});

  factory ToolkitCategory.fromJson(Map<String, dynamic> json) {
    var tagsList = json['tags'] as List?;

    return ToolkitCategory(
      id: json['id'],
      longTitle: json['longTitle'],
      slug: json['slug'],
      tags: tagsList?.cast<String>(),
      title: json['title'],
    );
  }
}
