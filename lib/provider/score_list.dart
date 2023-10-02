import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'score_list.g.dart';

@riverpod
class ScoreListNotifier extends _$ScoreListNotifier {
  @override
  List<int> build() {
    return [];
  }

  int pop() {
    print(state);
    if (state.isEmpty) {
      return 0;
    }
    return state.removeLast();
  }

  void push(int score) {
    final oldState = state;
    final newState = [...oldState, score];
    state = newState;
    print(state);
  }

  int sum() {
    int ans = 0;
    for (int i = 0; i < state.length; i++) {
      ans += state[i];
    }
    return ans;
  }

  void clean() {
    state = [];
  }
}
