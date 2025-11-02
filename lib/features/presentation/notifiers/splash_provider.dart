import 'package:flutter_riverpod/flutter_riverpod.dart';

final splashProvider = FutureProvider.autoDispose<bool>((ref) async {
  await Future.delayed(const Duration(seconds: 3)); // Simulate loading time

  return true;
});
