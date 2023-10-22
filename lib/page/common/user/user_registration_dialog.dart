import 'package:darts_record_app/database/user_info_table.dart';
import 'package:darts_record_app/provider/login_user_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRegistrationDialog extends ConsumerWidget {
  UserRegistrationDialog({super.key});
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text("User Registration",
          style: TextStyle(
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
            child: const Text("Cancel")),
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
                int id = await UserInfoTable().insert(controller.text);
                ref.read(loginUserIdNotifierProvider.notifier).updateState(id);
              }
            },
            child: const Text("Save")),
      ],
    );
  }
}
