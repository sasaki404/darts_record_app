import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveLoginUserId(int id) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('loginUserId', id);
}

Future<int> loadLoginUserId() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final val = prefs.getInt('loginUserId');
  return val ?? -1; // ログインしていないとき-1
}
