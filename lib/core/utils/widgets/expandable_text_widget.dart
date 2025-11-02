// import 'package:beprepared/core/resources/all_imports.dart';
// import 'package:flutter/material.dart';

// class ExpandableText extends ConsumerWidget {
//   final String text;
//   final int maxLines;
//   final bool isSavedSearch;
//   final String uniqueId; // A unique identifier for each instance

//   const ExpandableText(
//     this.text, {
//     this.maxLines = 5,
//     this.isSavedSearch = false,
//     required this.uniqueId,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isExpanded = ref.watch(expandableTextProvider(uniqueId));
//     final lineCount = _calculateLines(context, text);
//     final shouldShowViewMore = lineCount > maxLines;
//     final remainingLines = lineCount - maxLines;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           text,
//           maxLines: isExpanded ? null : maxLines,
//           overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
//           style: TextStyle(
//             fontSize: 12.sp,
//             color: AppColors.greyTextColor,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         SizedBox(height: 16.h),
//         if (shouldShowViewMore)
//           GestureDetector(
//             onTap: () => ref
//                 .read(expandableTextProvider(uniqueId).notifier)
//                 .state = !isExpanded,
//             child: Text(
//               isExpanded
//                   ? 'View less'
//                   : isSavedSearch
//                       ? '+$remainingLines More filters'
//                       : 'View more',
//               style: TextStyle(
//                 fontSize: 12.sp,
//                 color: AppColors.greyTextColor,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   // Function to calculate the number of lines based on text and style, using TextPainter for accuracy
//   int _calculateLines(BuildContext context, String text) {
//     final textStyle = TextStyle(fontSize: 12.sp);
//     final textSpan = TextSpan(text: text, style: textStyle);
//     final textPainter = TextPainter(
//       text: textSpan,
//       maxLines: null,
//       textDirection: TextDirection.,
//     );
//     textPainter.layout(
//         maxWidth: MediaQuery.of(context)
//             .size
//             .width); // Layout the text within the width of the device screen
//     return textPainter.computeLineMetrics().length;
//   }
// }
