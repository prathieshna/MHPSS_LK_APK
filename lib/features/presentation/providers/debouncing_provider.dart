import 'dart:async';

import 'package:beprepared/core/resources/all_imports.dart';

class Debounce {
  final Duration duration;
  Timer? _timer;

  Debounce({required this.duration});

  void call(Function action) {
    _timer?.cancel();
    _timer = Timer(duration, action as void Function());
  }
}

final debounceProvider = Provider((ref) {
  return Debounce(
      duration: Duration(milliseconds: 500)); // Adjust duration as needed
});
