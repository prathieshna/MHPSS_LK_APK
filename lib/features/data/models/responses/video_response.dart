class VideoResponse {
  final VideoData data;

  VideoResponse({required this.data});

  factory VideoResponse.fromJson(Map<String, dynamic> json) {
    return VideoResponse(
      data: VideoData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data.toJson(),
      };
}

class VideoData {
  final List<Video> videos;

  VideoData({required this.videos});

  factory VideoData.fromJson(Map<String, dynamic> json) {
    return VideoData(
      videos: (json['videos'] as List?)
              ?.map((videoJson) => Video.fromJson(videoJson))
              .toList() ??
          [], // fallback to empty list if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'videos': videos.map((video) => video.toJson()).toList(),
    };
  }
}

class Video {
  final String title;
  final String videoUrl;

  Video({required this.title, required this.videoUrl});

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      title: json['title'],
      videoUrl: json['videoUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'videoUrl': videoUrl,
      };
}
