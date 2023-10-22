import 'package:darts_record_app/kv/login_user_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'login_user_id.g.dart';

@riverpod
class LoginUserIdNotifier extends _$LoginUserIdNotifier {
  @override
  Future<int> build() {
    return loadLoginUserId();
  }

  // 状態を更新する
  Future<void> updateState(int id) async {
    saveLoginUserId(id);
    state = AsyncData(id);
  }
}
