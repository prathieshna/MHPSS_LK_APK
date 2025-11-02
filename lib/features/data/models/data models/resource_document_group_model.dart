import 'package:beprepared/features/data/models/responses/single_resource_response.dart';

class ResourceDocumentGroups {
  final SingleResourceDocument? pdfDocument;
  final SingleResourceDocument? audioDocument;
  final SingleResourceDocument? videoDocument;

  ResourceDocumentGroups({
    this.pdfDocument,
    this.audioDocument,
    this.videoDocument,
  });

  factory ResourceDocumentGroups.fromResource(SingleResourceDetails? resource) {
    if (resource?.resourceDocument == null) {
      return ResourceDocumentGroups();
    }

    return ResourceDocumentGroups(
      pdfDocument: resource!.resourceDocument!.firstWhereOrNull((doc) =>
          (doc.fileFormat?.toLowerCase() == 'pdf') || (doc.fileFormat == null)),
      audioDocument: resource.resourceDocument!.firstWhereOrNull(
          (doc) => (doc.fileFormat?.toLowerCase() == 'audio')),
      videoDocument: resource.resourceDocument!.firstWhereOrNull(
          (doc) => (doc.fileFormat?.toLowerCase() == 'video')),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pdfDocument': pdfDocument?.toJson(),
      'audioDocument': audioDocument?.toJson(),
      'videoDocument': videoDocument?.toJson(),
    };
  }

  @override
  String toString() =>
      'ResourceDocumentGroups(pdfDocument: $pdfDocument, audioDocument: $audioDocument, videoDocument: $videoDocument)';
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
