import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'is_finished.g.dart';

@riverpod
class IsFinishedNotifier extends _$IsFinishedNotifier {
  @override
  bool build() {
    return false;
  }

  // 状態を更新する
  void updateState(bool b) {
    state = b;
  }
}
