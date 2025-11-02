import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkImageWidget extends StatelessWidget {
  final String? imageURL;
  final double? height;
  final double? width;
  final double scale;
  final BoxFit? boxFit;

  const NetworkImageWidget({
    super.key,
    required this.imageURL,
    this.height,
    this.width,
    this.scale = 1.0,
    this.boxFit,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageURL ?? "",
      height: height,
      width: width,
      fit: boxFit ?? BoxFit.fitWidth,
      fadeInDuration: const Duration(milliseconds: 500),
      placeholderFadeInDuration: const Duration(milliseconds: 500),
      progressIndicatorBuilder: (context, url, progress) {
        return Center(
          child: CircularProgressIndicator(
            value: progress.progress,
            strokeWidth: 2.0,
          ),
        );
      },
      errorWidget: (context, url, error) {
        return height != null
            ? SizedBox(
                height: height!,
                child: const Icon(Icons.image, color: Colors.grey),
              )
            : const Icon(Icons.image, color: Colors.grey);
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Image.network(
  //     imageURL ?? "",
  //     scale: scale,
  //     fit: boxFit ?? BoxFit.fitWidth,
  //     height: height,
  //     width: width,
  //     loadingBuilder: (context, child, loadingProgress) {
  //       if (loadingProgress == null) return child;
  //       return Center(
  //         child: CircularProgressIndicator(
  //           value: loadingProgress.expectedTotalBytes != null
  //               ? loadingProgress.cumulativeBytesLoaded /
  //                   loadingProgress.expectedTotalBytes!
  //               : null,
  //         ),
  //       );
  //     },
  //     errorBuilder: (context, error, stackTrace) {
  //       // print('Error loading image: $error'); // Log the error
  //       return height != null
  //           ? SizedBox(
  //               height: height!,
  //               child: const Icon(Icons.error, color: Colors.red),
  //             )
  //           : const Icon(Icons.error, color: Colors.red);
  //     },
  //   );
  // }
}
