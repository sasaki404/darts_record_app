import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'target_index.g.dart';

// バーのインデックス
// memo: 
//$ dart run build_runner build --delete-conflicting-outputs
@riverpod // ←このアノテーションを忘れるとファイルが生成されない
class TargetIndexNotifier extends _$TargetIndexNotifier {
  @override
  int build() {
    return 0;
  }

  // 状態を更新する
  void setIndex(int index) {
    state = index;
  }
}