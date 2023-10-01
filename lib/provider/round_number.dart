import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'round_number.g.dart';

@riverpod
class RoundNumberNotifier extends _$RoundNumberNotifier {
  @override
  int build() {
    return 1;
  }

  // 状態を更新する
  void updateState(int round) {
    state = round;
  }

  void toNextRound() {
    state += 1;
  }

  void toPrevRound() {
    if (state >= 2) {
      state -= 1;
    }
  }
}
