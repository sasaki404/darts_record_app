import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'round_score.g.dart';

@riverpod
class RoundScoreNotifier extends _$RoundScoreNotifier {
  @override
  Map<int, List<String>> build() {
    return {};
  }

  void pop(int id) {
    if (!state.containsKey(id) || state[id]!.isEmpty) {
      return;
    }
    state[id]!.removeLast();
  }

  void push(int id, String score) {
    final oldState = state;
    oldState.putIfAbsent(id, () => []);
    oldState[id]!.add(score);
    state = oldState;
  }

  void clean(int id) {
    state[id] = [];
  }
}
