import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'is_darts_board_display.g.dart';

@riverpod
class IsDartsBoardDisplayNotifier extends _$IsDartsBoardDisplayNotifier {
  @override
  bool build() {
    return true;
  }

  // 状態を更新する
  void updateState(bool b) {
    state = b;
  }
}
