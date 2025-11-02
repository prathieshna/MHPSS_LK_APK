import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppWidgets {
  static const double fullScreenHorizontalPaddingValue = 24.0;
  static const double fullScreenVerticalPaddingValue = 20.0;
  static const double borderRadiusValue = 28.0;
  static const double halfBorderRadiusValue = borderRadiusValue / 2;
  static const double verticalGapValue = 24.0;
  static const double horizontalGapValue = 24.0;
  static const double googleMapsZoomLevel = 18.0;
  static const double dropDownMenuHeight = 300.0;
  static const double viewDocumentHeight = 224.0;

  static const EdgeInsets fullScreenPadding = EdgeInsets.symmetric(
    horizontal: fullScreenHorizontalPaddingValue,
  );

  static const EdgeInsets fullScreenHorizontalPadding = EdgeInsets.symmetric(
    horizontal: fullScreenHorizontalPaddingValue,
  );

  static final BorderRadius borderRadius =
      BorderRadius.circular(borderRadiusValue);

  static final BorderRadius halfBorderRadius =
      BorderRadius.circular(borderRadiusValue / 2);

  static const verticalGap = SizedBox(height: verticalGapValue);
  static const doubleVerticalGap = SizedBox(height: verticalGapValue * 2);
  static const halfVerticalGap = SizedBox(height: verticalGapValue / 2);

  static const horizontalGap = SizedBox(width: horizontalGapValue);
  static const halfHorizontalGap = SizedBox(width: horizontalGapValue / 2);

  static const linearGradient = LinearGradient(
    colors: [Colors.white, Colors.white],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final listTileShape = RoundedRectangleBorder(
    side: BorderSide(color: Colors.grey.withOpacity(0.3)),
    borderRadius: AppWidgets.halfBorderRadius,
  );

  static RoundedRectangleBorder topBorderRadiusOnly(bool isPressed) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: const Radius.circular(AppWidgets.halfBorderRadiusValue),
        topLeft: const Radius.circular(AppWidgets.halfBorderRadiusValue),
        bottomLeft: Radius.circular(
          isPressed ? 0 : AppWidgets.halfBorderRadiusValue,
        ),
        bottomRight: Radius.circular(
          isPressed ? 0 : AppWidgets.halfBorderRadiusValue,
        ),
      ),
    );
  }

  static BorderRadius bottomBorderRadius = const BorderRadius.only(
    bottomLeft: Radius.circular(AppWidgets.halfBorderRadiusValue),
    bottomRight: Radius.circular(AppWidgets.halfBorderRadiusValue),
  );

  static final charactersOnlyInputFormatter = [
    FilteringTextInputFormatter.allow(
      RegExp(r'[a-zA-Z0-9]'),
    ),
    FilteringTextInputFormatter.allow(RegExp(r'[^0-9]'))
  ];
}
