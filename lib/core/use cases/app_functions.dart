import 'dart:math';

import 'package:beprepared/core/resources/all_imports.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class IAppFunctions {
  Future notificationPermission();
  String formatNumber(dynamic value);
  Future<void> openGoogleMaps(String address);
  Future<void> openDialer(String? phoneNumber);
  Future<void> openWhatsApp(BuildContext context, String? phoneNumber,
      [String? message]);
  Future<void> openEmailApp(String emailAddress);
  Future<void> openWebUrl(String url);
  Future<String> generateRandomString(int length);
  Future<String> removeHiddenCharacters(String input);
  String removeCommaAndAlphabets(String input);
  String convertToLowerUnderscore(String input);
  String convertToTitleCase(String input);
  String formatTextFeatures(String input);
  bool isSameDay(DateTime date1, DateTime date2);
  bool isWithinSameDay(DateTime date1, DateTime date2);
  String getCreatedAt(DateTime createdAt);
  String getCreatedAtChatTimer(DateTime createdAt);

  Future<String?> downloadFile(String url, String fileName);
  Future<String?> downloadAndSaveImage(String imageUrl, String fileName);
  Future<List<FileSystemEntity>> listDownloadedFiles();
  void deleteFile(int index);
  String parseHtmlToPlainText(String htmlString);
}

class AppFunctions implements IAppFunctions {
  AppFunctions._privateConstructor();

  static final AppFunctions instance = AppFunctions._privateConstructor();

  factory AppFunctions() {
    return instance;
  }

  ////////////////////////////////////////////////////////////////////
  /// Open URL functions
  ////////////////////////////////////////////////////////////////////

  @override
  Future notificationPermission() async {
    final PermissionStatus status = await Permission.notification.request();
    print("PermissionStatus: $status");
    if (status.isGranted) {
      // Notification permissions granted
    } else if (status.isDenied) {
      // Notification permissions denied
      Permission.notification.request();
    } else if (status.isPermanentlyDenied) {
      // Notification permissions permanently denied, open app settings
      await openAppSettings();
    }
  }

  @override
  Future<void> openGoogleMaps(String address) async {
    if (address.isEmpty) {
      Utils.displayToast("Don't have an address");
      return;
    }
    // URL encode the address to handle spaces and special characters
    final encodedAddress = Uri.encodeComponent(address);
    final url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$encodedAddress');

    // Use canLaunchUrl to check if the URL can be launched
    try {
      if (await canLaunchUrl(url)) {
        // Use launchUrl to open the URL
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      Utils.displayToast(e.toString());
    }
  }

  @override
  Future<void> openDialer(String? phoneNumber) async {
    final String cleanNumber = await removeHiddenCharacters(phoneNumber ?? "");
    if (cleanNumber.isEmpty) {
      Utils.displayToast("Don't have any phone number");
      return;
    }
    final Uri launchUri = Uri(scheme: 'tel', path: cleanNumber);

    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        throw 'Could not launch ${launchUri.path}';
      }
    } catch (e) {
      Utils.displayToast(e.toString());
    }
  }

  @override
  Future<void> openWhatsApp(BuildContext context, String? phoneNumber,
      [String? message]) async {
    final String cleanNumber = await removeHiddenCharacters(phoneNumber ?? "");

    if (cleanNumber.isEmpty) {
      Utils.displayToast("Don't have any phone number");
      return;
    }

    var whatsappUrlPlatform = "https://wa.me/$cleanNumber";

    // Append the message if provided
    if (message != null && message.isNotEmpty) {
      // whatsappUrlAndroid += "&text=${Uri.encodeComponent(message)}";
      whatsappUrlPlatform += "?text=${Uri.encodeComponent(message)}";
    }

    final Uri whatsappUrl = Uri.parse(whatsappUrlPlatform);

    // Check if the URL can be launched and launch it
    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl);
      } else {
        throw 'Could not launch $whatsappUrl';
      }
    } catch (e) {
      Utils.displayToast(e.toString());
    }
  }

  @override
  Future<void> openEmailApp(String emailAddress) async {
    if (emailAddress.isEmpty) {
      Utils.displayToast("Don't have any email address");
      return;
    }

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
      query: Uri.encodeFull('subject=&body='),
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        throw 'Could not launch email: ${emailUri.path}';
      }
    } catch (e) {
      Utils.displayToast(e.toString());
    }
  }

  @override
  Future<void> openWebUrl(String url) async {
    if (url.isEmpty) {
      Utils.displayToast("Don't have any url");
      return;
    }

    final Uri launchUri = Uri.parse(url);

    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        throw 'Could not launch $launchUri';
      }
    } catch (e) {
      Utils.displayToast(e.toString());
    }
  }

  ////////////////////////////////////////////////////////////////////
  /// Generate Random String
  ///////////////////////////////////////////////////////////////////

  @override
  Future<String> generateRandomString(int length) async {
    const characters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();

    final generatedString = List.generate(
            length, (index) => characters[random.nextInt(characters.length)])
        .join();
    print("randomGeneratedString: $generatedString");

    // await storage.setHiveValue("randomGeneratedString", generatedString);

    return generatedString;
  }

  ///////////////////////////////////////////////////////////////////////
  /// Text formating Helper functions
  ///////////////////////////////////////////////////////////////////////

  @override
  String formatNumber(dynamic value) {
    final formatter = NumberFormat('#,###');
    return formatter.format(value);
  }

  @override
  Future<String> removeHiddenCharacters(String input) async {
    return input.replaceAll(RegExp(r'[^+\d]'), '');
  }

  @override
  String convertToLowerUnderscore(String input) {
    return input.toLowerCase().replaceAll(' ', '_');
  }

  @override
  String removeCommaAndAlphabets(String input) {
    return input.replaceAll(RegExp(r'[^0-9]'), '');
  }

  @override
  String convertToTitleCase(String input) {
    String modifiedString = input.replaceAll('_', ' ');

    // Capitalize the first letter of the modified string
    if (modifiedString.isNotEmpty) {
      return modifiedString[0].toUpperCase() + modifiedString.substring(1);
    }

    return modifiedString;
  }

  @override
  String formatTextFeatures(String input) {
    return input
        .replaceAll('&amp;', '& Amp,')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  ///////////////////////////////////////////////////////////////////////
  /// Date formating Helper functions
  ///////////////////////////////////////////////////////////////////////

  @override
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  bool isWithinSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  String getCreatedAt(DateTime createdAt) {
    DateTime now = DateTime.now();

    if (isWithinSameDay(createdAt, now)) {
      Duration difference = now.difference(createdAt);

      if (difference.inMinutes < 60) {
        int differenceInMinutes = difference.inMinutes;
        if (differenceInMinutes == 0) {
          return 'Just now';
        } else if (differenceInMinutes == 1) {
          return '1m ago';
        } else {
          return '${differenceInMinutes}m ago';
        }
      } else {
        int differenceInHours = difference.inHours;
        if (differenceInHours == 1) {
          return '1 hour ago';
        } else {
          return '$differenceInHours hours ago';
        }
      }
    } else if (isSameDay(createdAt, now)) {
      return 'Today';
    } else if (isSameDay(createdAt, now.subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    } else {
      return DateFormat('dd MMM yyyy').format(createdAt).toString();
    }
  }

  @override
  String getCreatedAtChatTimer(DateTime createdAt) {
    DateTime now = DateTime.now();

    // if (isWithinSameDay(createdAt, now)) {
    //   return DateFormat('h:mm a').format(createdAt).toString();
    // } else
    if (isSameDay(createdAt, now)) {
      return 'Today';
    } else if (isSameDay(createdAt, now.subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    } else {
      return DateFormat('dd MMM yyyy').format(createdAt).toString();
    }
  }

  ///////////////////////////////////////////////////////////////////////
  ///
  ///////////////////////////////////////////////////////////////////////

  static Future<String?> getdeviceId() async {
    //create an instance of the deviceInfoPlugin
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    //check the device platform
    if (Platform.isAndroid) {
      var deviceInfo = await deviceInfoPlugin.androidInfo;
      return deviceInfo.id;
    } else {
      var deviceInfo = await deviceInfoPlugin.iosInfo;
      return deviceInfo.identifierForVendor;
    }
  }

  @override
  Future<String?> downloadFile(String url, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = "${dir.path}/$fileName-${await generateRandomString(4)}";

    try {
      // Download the file
      final response = await Dio().download(url, filePath);

      if (response.statusCode == 200) {
        print("File downloaded and saved: $filePath");
        return filePath;
      } else {
        print("Failed to download file: ${response.statusCode}");
      }
    } catch (e) {
      print("Error downloading file: $e");
    }
    return null;
  }

  @override
  Future<String?> downloadAndSaveImage(String imageUrl, String fileName) async {
    if (imageUrl.isEmpty) return null;

    final dir = await getApplicationDocumentsDirectory();
    final imageFileName = "img_$fileName";
    final imagePath = "${dir.path}/$imageFileName";

    try {
      // Check if image already exists
      if (await File(imagePath).exists()) {
        return imagePath;
      }

      // Download the image
      final response = await Dio().download(imageUrl, imagePath);

      if (response.statusCode == 200) {
        print("Image downloaded and saved: $imagePath");
        return imagePath;
      } else {
        print("Failed to download image: ${response.statusCode}");
      }
    } catch (e) {
      print("Error downloading image: $e");
    }
    return null;
  }

  @override
  Future<List<FileSystemEntity>> listDownloadedFiles() async {
    final dir = await getApplicationDocumentsDirectory();
    return Directory(dir.path)
        .listSync()
        .where((entity) => FileSystemEntity.isFileSync(entity.path))
        .toList();
  }

  @override
  Future<void> deleteFile(int index) async {
    try {
      final box = await Hive.openBox<DownloadedFile>('downloads');
      final downloadedFile = box.getAt(index);

      if (downloadedFile != null) {
        // Delete the main file
        final file = File(downloadedFile.filePath ?? "");
        if (await file.exists()) {
          await file.delete();
          print("File deleted from filesystem: ${downloadedFile.fileName}");
        }

        // Delete the associated image if it exists
        if (downloadedFile.imagePath != null) {
          final imageFile = File(downloadedFile.imagePath ?? "");
          if (await imageFile.exists()) {
            await imageFile.delete();
            print("Image deleted from filesystem: ${downloadedFile.imagePath}");
          }
        }

        // Remove from Hive
        box.deleteAt(index);
        print("Records deleted from Hive: ${downloadedFile.fileName}");
      }
    } catch (e) {
      print("Error deleting file: $e");
    }
  }

  @override
  String parseHtmlToPlainText(String htmlString) {
    // Remove the outer <p><code> tags
    htmlString = htmlString
        .replaceAll(RegExp(r'<p><code>|</code></p>'), '')

        // Decode HTML entities
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&amp;', '&')

        // Remove all HTML tags
        .replaceAll(RegExp(r'<[^>]*>'), ' ')

        // Remove DOCTYPE and other HTML structure tags
        .replaceAll('<!DOCTYPE html>', '')
        .replaceAll('<html lang="en">', '')
        .replaceAll('<head>', '')
        .replaceAll('</head>', '')
        .replaceAll('<body>', '')
        .replaceAll('</body>', '')
        .replaceAll('<div>', '')
        .replaceAll('</div>', '')

        // Remove href attributes
        .replaceAll(RegExp(r'href="[^"]*"'), '')

        // Replace multiple spaces with single space
        .replaceAll(RegExp(r'\s+'), ' ')

        // Trim leading and trailing spaces
        .trim();

    return htmlString;
  }
}
