class ToolkitResponse {
  final Toolkit? toolkit;

  ToolkitResponse({this.toolkit});

  factory ToolkitResponse.fromJson(Map<String, dynamic> json) {
    return ToolkitResponse(
      toolkit: json['data']['toolkit'] != null
          ? Toolkit.fromJson(json['data']['toolkit'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'toolkit': toolkit?.toJson(),
      },
    };
  }
}

class Toolkit {
  final String? version;
  final List<ToolkitAllCategory>? toolkitAllCategories;

  Toolkit({this.version, this.toolkitAllCategories});

  factory Toolkit.fromJson(Map<String, dynamic> json) {
    return Toolkit(
      version: json['version'],
      toolkitAllCategories: (json['toolkitCategories'] as List<dynamic>?)
          ?.map((e) => ToolkitAllCategory.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'toolkitCategories':
          toolkitAllCategories?.map((e) => e.toJson()).toList(),
    };
  }
}

class ToolkitAllCategory {
  final String id;
  final String title;
  final String slug;
  final ToolkitImage? image;

  ToolkitAllCategory({
    required this.id,
    required this.title,
    required this.slug,
    this.image,
  });

  factory ToolkitAllCategory.fromJson(Map<String, dynamic> json) {
    return ToolkitAllCategory(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      image:
          json['image'] != null ? ToolkitImage.fromJson(json['image']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'image': image?.toJson(),
    };
  }
}

class ToolkitImage {
  final String? caption;
  final String? id;
  final String? locale;
  final String? url;

  ToolkitImage({
    this.caption,
    required this.id,
    required this.locale,
    required this.url,
  });

  factory ToolkitImage.fromJson(Map<String, dynamic> json) {
    return ToolkitImage(
      caption: json['caption'],
      id: json['id'],
      locale: json['locale'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'caption': caption,
      'id': id,
      'locale': locale,
      'url': url,
    };
  }
}
