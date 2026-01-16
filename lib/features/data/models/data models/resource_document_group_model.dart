import 'package:mhpss_app/features/data/models/responses/single_resource_response.dart';

class ResourceDocumentGroups {
  final List<SingleResourceDocument> pdfDocuments;
  final List<SingleResourceDocument> audioDocuments;
  final List<SingleResourceDocument> videoDocuments;

  ResourceDocumentGroups({
    this.pdfDocuments = const [],
    this.audioDocuments = const [],
    this.videoDocuments = const [],
  });

  // Convenience getters for backwards compatibility
  SingleResourceDocument? get pdfDocument => pdfDocuments.isNotEmpty ? pdfDocuments.first : null;
  SingleResourceDocument? get audioDocument => audioDocuments.isNotEmpty ? audioDocuments.first : null;
  SingleResourceDocument? get videoDocument => videoDocuments.isNotEmpty ? videoDocuments.first : null;

  factory ResourceDocumentGroups.fromResource(SingleResourceDetails? resource) {
    if (resource?.resourceDocument == null) {
      return ResourceDocumentGroups();
    }

    return ResourceDocumentGroups(
      pdfDocuments: resource!.resourceDocument!
          .where((doc) => (doc.fileFormat?.toLowerCase() == 'pdf') || (doc.fileFormat == null))
          .toList(),
      audioDocuments: resource.resourceDocument!
          .where((doc) => (doc.fileFormat?.toLowerCase() == 'audio'))
          .toList(),
      videoDocuments: resource.resourceDocument!
          .where((doc) => (doc.fileFormat?.toLowerCase() == 'video'))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pdfDocuments': pdfDocuments.map((doc) => doc.toJson()).toList(),
      'audioDocuments': audioDocuments.map((doc) => doc.toJson()).toList(),
      'videoDocuments': videoDocuments.map((doc) => doc.toJson()).toList(),
    };
  }

  @override
  String toString() =>
      'ResourceDocumentGroups(pdfDocuments: $pdfDocuments, audioDocuments: $audioDocuments, videoDocuments: $videoDocuments)';
}

extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

// class ResourceDocumentGroups {
//   final SingleResourceDocument? pdfDocument;
//   final SingleResourceDocument? audioDocument;
//   final SingleResourceDocument? videoDocument;

//   ResourceDocumentGroups({
//     this.pdfDocument,
//     this.audioDocument,
//     this.videoDocument,
//   });

//   factory ResourceDocumentGroups.fromResource(SingleResourceDetails? resource) {
//     if (resource?.resourceDocument == null) {
//       return ResourceDocumentGroups();
//     }

//     return ResourceDocumentGroups(
//       pdfDocument: resource!.resourceDocument!.firstWhereOrNull(
//         (doc) => doc.fileFormat?.toLowerCase() == 'pdf',
//       ),
//       audioDocument: resource.resourceDocument!.firstWhereOrNull(
//         (doc) => doc.fileFormat?.toLowerCase() == 'audio online site',
//       ),
//       videoDocument: resource.resourceDocument!.firstWhereOrNull(
//         (doc) => doc.fileFormat?.toLowerCase() == 'video online site',
//       ),
//     );
//   }
// }

// extension FirstWhereOrNullExtension<E> on Iterable<E> {
//   E? firstWhereOrNull(bool Function(E) test) {
//     for (E element in this) {
//       if (test(element)) return element;
//     }
//     return null;
//   }
// }
