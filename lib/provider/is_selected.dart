import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'is_selected.g.dart';

@riverpod
class IsSelectedNotifier extends _$IsSelectedNotifier {
  @override
  bool build() {
    return false;
  }

  // 状態を更新する
  void updateState() {
    final old = state;
    state = !old;
  }
}
