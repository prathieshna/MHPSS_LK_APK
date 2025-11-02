class SearchResponse {
  final List<Hit>? hits;
  final int? nbHits;
  final int? page;
  final int? nbPages;
  final int? hitsPerPage;
  final bool? exhaustiveNbHits;
  final bool? exhaustiveTypo;
  final Exhaustive? exhaustive;
  final String? query;
  final String? params;
  final int? processingTimeMS;
  final ProcessingTimingsMS? processingTimingMS;
  final int? serverTimeMS;

  SearchResponse({
    this.hits,
    this.nbHits,
    this.page,
    this.nbPages,
    this.hitsPerPage,
    this.exhaustiveNbHits,
    this.exhaustiveTypo,
    this.exhaustive,
    this.query,
    this.params,
    this.processingTimeMS,
    this.processingTimingMS,
    this.serverTimeMS,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
        hits: json['hits'] != null
            ? List<Hit>.from(json['hits'].map((x) => Hit.fromJson(x)))
            : null,
        nbHits: json['nbHits'],
        page: json['page'],
        nbPages: json['nbPages'],
        hitsPerPage: json['hitsPerPage'],
        exhaustiveNbHits: json['exhaustiveNbHits'],
        exhaustiveTypo: json['exhaustiveTypo'],
        exhaustive: json['exhaustive'] != null
            ? Exhaustive.fromJson(json['exhaustive'])
            : null,
        query: json['query'],
        params: json['params'],
        processingTimeMS: json['processingTimeMS'],
        processingTimingMS: json['processingTimingsMS'] != null
            ? ProcessingTimingsMS.fromJson(json['processingTimingsMS'])
            : null,
        serverTimeMS: json['serverTimeMS'],
      );

  Map<String, dynamic> toJson() => {
        'hits': hits?.map((x) => x.toJson()).toList(),
        'nbHits': nbHits,
        'page': page,
        'nbPages': nbPages,
        'hitsPerPage': hitsPerPage,
        'exhaustiveNbHits': exhaustiveNbHits,
        'exhaustiveTypo': exhaustiveTypo,
        'exhaustive': exhaustive?.toJson(),
        'query': query,
        'params': params,
        'processingTimeMS': processingTimeMS,
        'processingTimingsMS': processingTimingMS?.toJson(),
        'serverTimeMS': serverTimeMS,
      };
}

class Hit {
  final String? author;
  final String? description;
  final dynamic pages;
  final String? publishingDate;
  final String? slug;
  final String? title;
  final Toolkit? toolkit;
  final ImageHit? imageHit;
  final List<Category>? categories;
  final List<String>? type;
  final List<dynamic>? tags;
  final String? objectID;
  final HighlightResult? highlightResult;

  Hit({
    this.author,
    this.description,
    this.pages,
    this.publishingDate,
    this.slug,
    this.title,
    this.toolkit,
    this.imageHit,
    this.categories,
    this.type,
    this.tags,
    this.objectID,
    this.highlightResult,
  });

  factory Hit.fromJson(Map<String, dynamic> json) => Hit(
        author: json['author'],
        description: json['description'],
        pages: json['pages'],
        publishingDate: json['publishingDate'],
        slug: json['slug'],
        title: json['title'],
        toolkit:
            json['toolkit'] != null ? Toolkit.fromJson(json['toolkit']) : null,
        imageHit:
            json['image'] != null ? ImageHit.fromJson(json['image']) : null,
        categories: json['categories'] != null
            ? List<Category>.from(
                json['categories'].map((x) => Category.fromJson(x)))
            : null,
        type: json['type'] != null ? List<String>.from(json['type']) : null,
        tags: json['tags'] != null ? List<dynamic>.from(json['tags']) : null,
        objectID: json['objectID'],
        highlightResult: json['_highlightResult'] != null
            ? HighlightResult.fromJson(json['_highlightResult'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'author': author,
        'description': description,
        'pages': pages,
        'publishingDate': publishingDate,
        'slug': slug,
        'title': title,
        'toolkit': toolkit?.toJson(),
        'image': imageHit?.toJson(),
        'categories': categories?.map((x) => x.toJson()).toList(),
        'type': type,
        'tags': tags,
        'objectID': objectID,
        '_highlightResult': highlightResult?.toJson(),
      };

  @override
  String toString() {
    return toJson().toString();
  }
}

class Toolkit {
  final String? id;
  final String? title;
  final String? slug;

  Toolkit({
    this.id,
    this.title,
    this.slug,
  });

  factory Toolkit.fromJson(Map<String, dynamic> json) => Toolkit(
        id: json['id'],
        title: json['title'],
        slug: json['slug'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'slug': slug,
      };
}

class ImageHit {
  final String? id;
  final String? caption;
  final String? url;

  ImageHit({
    this.id,
    this.caption,
    this.url,
  });

  factory ImageHit.fromJson(Map<String, dynamic> json) => ImageHit(
        id: json['id'],
        caption: json['caption'],
        url: json['url'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'caption': caption,
        'url': url,
      };
}

class Category {
  final String? id;
  final String? title;
  final String? slug;

  Category({
    this.id,
    this.title,
    this.slug,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'],
        title: json['title'],
        slug: json['slug'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'slug': slug,
      };
}

class HighlightResult {
  final HighlightText? author;
  final HighlightText? description;
  final HighlightText? title;
  final ToolkitHighlight? toolkit;

  HighlightResult({
    this.author,
    this.description,
    this.title,
    this.toolkit,
  });

  factory HighlightResult.fromJson(Map<String, dynamic> json) =>
      HighlightResult(
        author: json['author'] != null
            ? HighlightText.fromJson(json['author'])
            : null,
        description: json['description'] != null
            ? HighlightText.fromJson(json['description'])
            : null,
        title: json['title'] != null
            ? HighlightText.fromJson(json['title'])
            : null,
        toolkit: json['toolkit'] != null
            ? ToolkitHighlight.fromJson(json['toolkit'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'author': author?.toJson(),
        'description': description?.toJson(),
        'title': title?.toJson(),
        'toolkit': toolkit?.toJson(),
      };
}

class HighlightText {
  final String? value;
  final String? matchLevel;
  final bool? fullyHighlighted;
  final List<String>? matchedWords;

  HighlightText({
    this.value,
    this.matchLevel,
    this.fullyHighlighted,
    this.matchedWords,
  });

  factory HighlightText.fromJson(Map<String, dynamic> json) => HighlightText(
        value: json['value'],
        matchLevel: json['matchLevel'],
        fullyHighlighted: json['fullyHighlighted'],
        matchedWords: json['matchedWords'] != null
            ? List<String>.from(json['matchedWords'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'value': value,
        'matchLevel': matchLevel,
        'fullyHighlighted': fullyHighlighted,
        'matchedWords': matchedWords,
      };
}

class ToolkitHighlight {
  final HighlightText? title;

  ToolkitHighlight({
    this.title,
  });

  factory ToolkitHighlight.fromJson(Map<String, dynamic> json) =>
      ToolkitHighlight(
        title: json['title'] != null
            ? HighlightText.fromJson(json['title'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'title': title?.toJson(),
      };
}

class Exhaustive {
  final bool? nbHits;
  final bool? typo;

  Exhaustive({
    this.nbHits,
    this.typo,
  });

  factory Exhaustive.fromJson(Map<String, dynamic> json) => Exhaustive(
        nbHits: json['nbHits'],
        typo: json['typo'],
      );

  Map<String, dynamic> toJson() => {
        'nbHits': nbHits,
        'typo': typo,
      };
}

class ProcessingTimingsMS {
  final Request? request;
  final int? total;

  ProcessingTimingsMS({
    this.request,
    this.total,
  });

  factory ProcessingTimingsMS.fromJson(Map<String, dynamic> json) =>
      ProcessingTimingsMS(
        request: json['_request'] != null
            ? Request.fromJson(json['_request'])
            : null,
        total: json['total'],
      );

  Map<String, dynamic> toJson() => {
        '_request': request?.toJson(),
        'total': total,
      };
}

class Request {
  final int? roundTrip;

  Request({
    this.roundTrip,
  });

  factory Request.fromJson(Map<String, dynamic> json) => Request(
        roundTrip: json['roundTrip'],
      );

  Map<String, dynamic> toJson() => {
        'roundTrip': roundTrip,
      };
}
