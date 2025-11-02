class OnboardingResponse {
  List<Screen>? onboardingScreens;

  OnboardingResponse({this.onboardingScreens});

  factory OnboardingResponse.fromJson(Map<String, dynamic> json) {
    return OnboardingResponse(
      onboardingScreens: (json['onboardingScreens'] as List<dynamic>?)
          ?.map((screen) => Screen.fromJson(screen))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'onboardingScreens':
          onboardingScreens?.map((screen) => screen.toJson()).toList(),
    };
  }
}

class Screen {
  String? title;
  String? language;
  String? description;
  Image? image;

  Screen({this.title, this.language, this.description, this.image});

  factory Screen.fromJson(Map<String, dynamic> json) {
    return Screen(
      title: json['title'] as String?,
      language: json['language'] as String?,
      description: json['description'] as String?,
      image: json['image'] != null ? Image.fromJson(json['image']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'language': language,
      'description': description,
      'image': image?.toJson(),
    };
  }
}

class Image {
  String? url;

  Image({this.url});

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      url: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }
}
