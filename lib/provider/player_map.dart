import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'player_map.g.dart';

@riverpod
class PlayerMapNotifier extends _$PlayerMapNotifier {
  // ユーザID:名前　のMap
  @override
  Map<int, String> build() {
    return {};
  }

  // 状態を更新する
  void updateState(int id, String name) {
    final old = state;
    old[id] = name;
    state = old;
  }

  // ユーザを追加
  void addUser(int id, String name) {
    final old = state;
    old.putIfAbsent(id, () => name);
    state = old;
  }

  // ユーザを更新
  void updateUser(int id, String name) {
    final old = state;
    old[id] = name;
    state = old;
  }
  void remove(int id) {
    final old = state;
    old.remove(id);
    state = old;
  }
}
