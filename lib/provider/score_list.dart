import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'score_list.g.dart';

@riverpod
class ScoreListNotifier extends _$ScoreListNotifier {
  @override
  Map<String, List<int>> build() {
    return {};
  }

  int pop(String key) {
    print(state[key]);
    if (!state.containsKey(key) || state[key]!.isEmpty) {
      return 0;
    }
    return state[key]!.removeLast();
  }

  void push(String key, int score) {
    final old = state;
    old.putIfAbsent(key, () => []);
    old[key]!.add(score);
    state = old;
    print(state);
  }

  int sum(String key) {
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
