import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'current_player_index.g.dart';

@riverpod
class CurrentPlayerIndexNotifier extends _$CurrentPlayerIndexNotifier {
  @override
  int build() {
    return 0;
  }

  // 状態を更新する
  void updateState(int i) {
    state = i;
  }
}
