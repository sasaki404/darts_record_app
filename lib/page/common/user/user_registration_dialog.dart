import 'package:darts_record_app/model/user_info.dart';
import 'package:darts_record_app/provider/login_user_id.dart';
import 'package:darts_record_app/provider/user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRegistrationDialog extends ConsumerWidget {
  final bool isEditMode;
  final int userId;
  final bool isLogin; // 登録したユーザをログインユーザにするか
  UserRegistrationDialog(
      {super.key,
      required this.isEditMode,
      this.userId = -1,
      this.isLogin = true});
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ユーザのリスト。DBから値を取得する
    final userInfo = ref.watch(userInfoNotifierProvider);
    // ログインしているユーザ
    late UserInfo ui;
    switch (userInfo) {
      // ユーザ情報を取得できたとき
      case AsyncData(:final value):
        {
          if (isEditMode) {
            // 編集モードの時は、ログインしているユーザを取得し、ユーザ名をテキストフィールドに表示
            ui = UserInfo.createMapfromList(value)[userId]!;
            controller.text = ui.name;
          }
        }
      // ユーザ情報を取得中
      case AsyncValue():
        const CircularProgressIndicator();
    }
    return AlertDialog(
      title: Text((isEditMode) ? "Edit Your Profile" : "User Registration",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )),
      content: TextFormField(
        controller: controller,
        decoration: const InputDecoration(
            labelText: "Name", border: OutlineInputBorder()),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            if (controller.text == "") {
              // 値が入力されなかったときエラーダイアログを表示
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text("Error",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      content: const Text("Please enter a name."),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("OK")),
                      ],
                    );
                  });
            } else {
              if (!isEditMode) {
                // 登録モードのとき
                int id = await ref
                    .read(userInfoNotifierProvider.notifier)
                    .insert(controller.text);
                if (isLogin) {
                  ref
                      .read(loginUserIdNotifierProvider.notifier)
                      .updateState(id);
                }
              } else {
                ui.name = controller.text;
                ref.read(userInfoNotifierProvider.notifier).updateState(ui);
              }
              if (context.mounted) Navigator.pop(context);
            }
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
