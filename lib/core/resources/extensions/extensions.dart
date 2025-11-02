import 'package:flutter/material.dart';

extension NullExtension on Object? {
  bool get isNotNull => this != null;
}

extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  Size get screenSize => MediaQuery.of(this).size;

  Brightness get brightness => Theme.of(this).brightness;

  void unFocus() => FocusScope.of(this).unfocus();

  NavigatorState get navigator => Navigator.of(this);

  // TODO learn about this and then add it
  // get overlay => this.loaderOverlay;
}

extension HexColor on Color {
  /// Converts a hex string (e.g., "#c79292" or "#C79292") to a Color object.
  static Color fromHex(String hexString) {
    // Remove the leading '#' if present
    hexString = hexString.replaceFirst('#', '');

    // Convert to uppercase
    hexString = hexString.toUpperCase();

    // Ensure the string is 6 or 8 characters long
    if (hexString.length == 6) {
      hexString = 'FF$hexString'; // Add full opacity alpha value
    } else if (hexString.length != 8) {
      throw ArgumentError(
          "Invalid color format. Expected format: RRGGBB or AARRGGBB.");
    }
    // Convert the hex string to a Color object
    return Color(int.parse(hexString, radix: 16));
  }

  /// Converts a Color object to a hex string.
  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

// Extension method to capitalize the first letter of a string
extension CapitalizeExtension on String {
  String capitalizeFirstLetter() {
    if (isEmpty) return '';
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

// extension DateTimeExtension on DateTime {
//   int toTimeStamp() => (millisecondsSinceEpoch / 1000).round();

//   String toBackendBasedFormattedString() {
//     return '${DateFormat('E MMM dd yyyy HH:mm:ss').format(this)} GMT+0500 (Pakistan Standard Time)';
//   }

//   String toSimpleString() => DateFormat('yyyy-MM-dd').format(this);

//   DateTime get absolute => DateTime(year, month, day);

//   String toSimpleDate() {
//     final dateFormat = DateFormat('MMM d, yyyy');
//     try {
//       return dateFormat.format(this);
//     } catch (e) {
//       return dateFormat.format(DateTime.now());
//     }
//   }

//   String toDayBasedSimpleDate() {
//     final dateFormat = DateFormat('EEEE d MMMM, yyyy');
//     try {
//       return dateFormat.format(this);
//     } catch (e) {
//       return dateFormat.format(DateTime.now());
//     }
//   }

//   String toSimpleTime() {
//     final dateFormat = DateFormat('hh:mm a');

//     try {
//       return dateFormat.format(this);
//     } catch (e) {
//       return dateFormat.format(DateTime.now());
//     }
//   }

//   TimeOfDay toTime() {
//     return TimeOfDay(hour: hour, minute: minute);
//   }
// }

// extension StringExtension on String {
//   String toLower() => toLowerCase().trim();

//   double toDouble() => double.parse(this);

//   String toFormattedPhone() =>
//       '+${substring(0, 2)} ${substring(2, 5)} ${substring(5)}';

//   String toFormattedCNIC() =>
//       '${substring(0, 5)} ${substring(5, length - 2)} ${substring(length - 1)}';

//   String extension() => substring(lastIndexOf('.') + 1, length).toLowerCase();

//   List<String> jsonDecodedPermissions() => jsonDecode(this)
//       .toString()
//       .replaceFirst('[', '')
//       .replaceFirst(']', '')
//       .replaceAll('"', '')
//       .replaceAll(' ', '')
//       .split(',');

//   DateTime toDate() {
//     try {
//       final dateFormat = DateFormat("MMM dd yyyy HH:mm:ss 'GMT'ZZZZ");

//       return dateFormat.parse(split(' ').sublist(1, 6).join(' '), true);
//     } catch (e) {
//       return DateTime.now();
//     }
//   }

//   bool ignoreCaseEqualsOrContains(String str) {
//     final str1 = toLowerCase();
//     final str2 = str.toLowerCase();

//     return str1 == str2 || str1.contains(str2) || str2.contains(str1);
//   }

//   bool get isLink {
//     try {
//       final uri = Uri.parse(this);
//       return uri.hasScheme && uri.hasAuthority;
//     } catch (e) {
//       return false;
//     }
//   }
// }

// extension LatLngExtension on LatLng {
//   LatLng fromJson(Json json) {
//     final latitude = json['latitude'].toString().toDouble();
//     final longitude = json['longitude'].toString().toDouble();

//     return LatLng(latitude, longitude);
//   }
// }

// extension ListExtension on List {
//   void inLocalStorage(String key) async {
//     await localStorage.write(key, jsonEncode(this));
//   }
// }

// extension TimeOfDayExtension on TimeOfDay {
//   String toSimpleString() =>
//       '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

//   String toSimpleTime() {
//     final now = DateTime.now();
//     final dateTime = DateTime(now.year, now.month, now.day, hour, minute);

//     return DateFormat.jm().format(dateTime);
//   }
// }
