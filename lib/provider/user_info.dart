import 'package:darts_record_app/database/user_info_table.dart';
import 'package:darts_record_app/model/user_info.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_info.g.dart';

@riverpod
class UserInfoNotifier extends _$UserInfoNotifier {
  @override
  Future<List<UserInfo>> build() async {
    return UserInfoTable().selectAll();
  }

  Future<int> insert(String name) async {
    int id = await UserInfoTable().insert(name);
    state = AsyncData(await UserInfoTable().selectAll());
    return id;
  }

  Future<void> updateState(UserInfo info) async {
    UserInfoTable().update(info);
    state = AsyncData(await UserInfoTable().selectAll());
  }

  Future<UserInfo> select(int id) {
    return UserInfoTable().selectById(id);
  }
}
