import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'award_str.g.dart';

@riverpod
class AwardStrNotifier extends _$AwardStrNotifier {
  @override
  String build() {
    return '';
  }

  // 状態を更新する
  void updateState(String str) {
    state = str;
  }
}