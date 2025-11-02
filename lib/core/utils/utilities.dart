import 'package:beprepared/core/resources/all_imports.dart';

class Utils {
  Utils._();

  static void displayToast(String? message) {
    if (message == null) return;

    Fluttertoast.showToast(
      msg: message,
      fontSize: 14.sp,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: AppColors.hintTextColor,
    );
  }
}
