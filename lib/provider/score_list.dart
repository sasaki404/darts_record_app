import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'score_list.g.dart';

@riverpod
class ScoreListNotifier extends _$ScoreListNotifier {
  @override
  Map<int, List<int>> build() {
    return {};
  }

  int pop(int key) {
    print(state[key]);
    if (!state.containsKey(key) || state[key]!.isEmpty) {
      return 0;
    }
    return state[key]!.removeLast();
  }

  void push(int key, int score) {
    final old = state;
    old.putIfAbsent(key, () => []);
    old[key]!.add(score);
    state = old;
    print(state);
  }

  int sum(int key) {
    if (!state.containsKey(key)) {
      return 0;
    }
    int ans = 0;
    for (int i = 0; i < state[key]!.length; i++) {
      ans += state[key]![i];
    }
    return ans;
  }

  void clean() {
    state = {};
  }
}
