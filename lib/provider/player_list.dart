import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'player_list.g.dart';

@riverpod
class PlayerListNotifier extends _$PlayerListNotifier {
  @override
  List<String> build() {
    return [];
  }

  void pop() {
    //return state.remove();
  }

  void push(String name) {
    if (!state.contains(name)) {
      state = [...state, name];
      print(state);
    }
  }

  void clean() {
    state = [];
  }
}
