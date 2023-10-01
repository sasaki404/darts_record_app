import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'total_score.g.dart';

@riverpod
class TotalScoreNotifier extends _$TotalScoreNotifier {
  @override
  int build() {
    return 0;
  }

  // 状態を更新する
  void updateState(int cnt) {
    state = cnt;
  }

  // スコアを加算する
  void addScore(int cnt) {
    state += cnt;
  }
}
