class PagesResponse {
  final PagesConnection pagesConnection;

  PagesResponse({required this.pagesConnection});

  factory PagesResponse.fromJson(Map<String, dynamic> json) {
    return PagesResponse(
      pagesConnection: PagesConnection.fromJson(json['pagesConnection']),
    );
  }
}

class PagesConnection {
  final List<Edge> edges;

  PagesConnection({required this.edges});

  factory PagesConnection.fromJson(Map<String, dynamic> json) {
    var edgesJson = json['edges'] as List;
    List<Edge> edgesList = edgesJson.map((i) => Edge.fromJson(i)).toList();

    return PagesConnection(edges: edgesList);
  }
}

class Edge {
  final Node node;

  Edge({required this.node});

  factory Edge.fromJson(Map<String, dynamic> json) {
    return Edge(
      node: Node.fromJson(json['node']),
    );
  }
}

class Node {
  final String title;
  final String? summary;
  final Content content;

  Node({required this.title, this.summary, required this.content});

  factory Node.fromJson(Map<String, dynamic> json) {
    return Node(
      title: json['title'],
      summary: json['summary'],
      content: Content.fromJson(json['content']),
    );
  }
}

class Content {
  final String html;

  Content({required this.html});

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      html: json['html'],
    );
  }
}
