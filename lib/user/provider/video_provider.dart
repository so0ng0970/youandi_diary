import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class SelectedVideoNotifier extends StateNotifier<List<XFile>> {
  SelectedVideoNotifier() : super([]);

  void insertVideo(XFile file) {
    state = [file];
  }

  removeVideo() {
    state = [];
  }
}

final selectedVideoProvider =
    StateNotifierProvider<SelectedVideoNotifier, List<XFile>>((ref) {
  return SelectedVideoNotifier();
});
final videoStateProvider = StateProvider((ref) => false);
