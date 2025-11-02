class Resource {
  final String title;
  final String description;
  final String author;
  final String publishedDate;
  final String imageUrl;
  final List<String> tags;
  final bool hasVideo;
  final bool isFavourite;

  Resource({
    required this.title,
    required this.description,
    required this.author,
    required this.publishedDate,
    required this.imageUrl,
    required this.tags,
    this.hasVideo = false,
    this.isFavourite = false,
  });
}

class ResourceDetails {
  final String title;
  final String description;
  final List<String> languages;
  final List<String> categories;
  final String author;
  final String publishedYear;

  ResourceDetails({
    required this.title,
    required this.description,
    required this.languages,
    required this.categories,
    required this.author,
    required this.publishedYear,
  });
}

class ResourceSelfCare {
  final String title;
  final String description;
  final String author;
  final String publishedDate;
  final String imageUrl;
  final List<String> tags;
  final bool hasVideo;
  final bool isFavourite;

  ResourceSelfCare({
    required this.title,
    required this.description,
    required this.author,
    required this.publishedDate,
    required this.imageUrl,
    required this.tags,
    this.hasVideo = false,
    this.isFavourite = false,
  });
}
