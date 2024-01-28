import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'player_list.g.dart';

@riverpod
class PlayerListNotifier extends _$PlayerListNotifier {
  @override
  List<int> build() {
    return [];
  }

  void pop() {
    //return state.remove();
  }

  void push(int id) {
    if (!state.contains(id)) {
      state = [...state, id];
      print(state);
    }
  }

  void remove(int id) {
    List<int> old = state;
    old.remove(id);
    state = old;
    print(state);
  }

  void clean() {
    state = [];
  }
}
