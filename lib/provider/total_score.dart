import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'total_score.g.dart';

@riverpod
class TotalScoreNotifier extends _$TotalScoreNotifier {
  @override
  Map<int, int> build() {
    return {};
  }

  // 状態を更新する
  void updateState(int key, int cnt) {
    final old = state;
    old[key] = cnt;
    state = old;
  }

  // スコアを加算する
  void addScore(int key, int cnt) {
    final old = state;
    old.putIfAbsent(key, () => 0);
    old[key] = old[key]! + cnt;
    state = old;
  }
}
