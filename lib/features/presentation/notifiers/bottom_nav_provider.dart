import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavNotifier extends StateNotifier<int> {
  BottomNavNotifier() : super(0);

  void setIndex(int index) {
    state = index;
  }
}

final bottomNavProvider = StateNotifierProvider<BottomNavNotifier, int>((ref) {
  return BottomNavNotifier();
});

final expandableTextProvider =
    StateProvider.family<bool, String>((ref, uniqueId) => false);
