import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'counter_str.g.dart';

@riverpod
class CounterStrNotifier extends _$CounterStrNotifier {
  @override
  String build() {
    return '';
  }

  // 状態を更新する
  void updateState(String str) {
    state = str;
  }
}