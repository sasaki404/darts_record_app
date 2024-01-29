import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'award_str.g.dart';

@riverpod
class AwardStrNotifier extends _$AwardStrNotifier {
  @override
  Map<int, String> build() {
    return {};
  }

  // 状態を更新する
  void updateState(int id, String str) {
    final old = state;
    old.putIfAbsent(id, () => "");
    old[id] = str;
    state = old;
  }
}
