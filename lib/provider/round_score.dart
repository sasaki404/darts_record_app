import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'round_score.g.dart';

@riverpod
class RoundScoreNotifier extends _$RoundScoreNotifier {
  @override
  List<int> build() {
    return [];
  }

  int pop() {
    if (state.isEmpty) {
      return 0;
    }
    return state.removeLast();
  }

  void push(int score) {
    final oldState = state;
    final newState = [...oldState, score];
    state = newState;
  }

  void clean() {
    state = [];
  }
}
