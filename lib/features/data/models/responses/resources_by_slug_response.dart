import 'package:mhpss_app/features/data/models/responses/single_resource_response.dart';

class ResourcesBySlugResponse {
  final List<SingleResourceDetails> resources;

  ResourcesBySlugResponse({required this.resources});

  factory ResourcesBySlugResponse.fromJson(Map<String, dynamic> json) {
    return ResourcesBySlugResponse(
      resources: (json['data']['resources'] as List<dynamic>?)
              ?.map((item) => SingleResourceDetails.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'resources': resources.map((r) => r.toJson()).toList(),
      },
    };
  }
}
