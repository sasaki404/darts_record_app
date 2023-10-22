import 'package:darts_record_app/model/user_info.dart';
import 'package:darts_record_app/page/common/user/user_registration_dialog.dart';
import 'package:darts_record_app/provider/login_user_id.dart';
import 'package:darts_record_app/provider/user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileCard extends ConsumerWidget {
  const UserProfileCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginUserId = ref.watch(loginUserIdNotifierProvider);
    final userInfo = ref.watch(userInfoNotifierProvider);
    return TextButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (_) {
              return UserRegistrationDialog();
            });
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 36,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(64),
                  child: Image.asset(
                    "assets/default_user.png",
                    width: 64,
                    height: 64,
                  ),
                ),
                const SizedBox(
                  width: 48,
                ),
                Flexible(
                  child: switch (loginUserId) {
                    AsyncData(:final value) =>
                      (value == -1) // ログインしているユーザがいないとき
                          ? const Column(
                              children: [
                                Text(
                                  "NO NAME",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Please input your name.",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              ],
                            )
                          : userInfo.when(
                              // whenメソッドでAsyncValueを使用
                              data: (data) {
                                UserInfo ui =
                                    UserInfo.createMapfromList(data)[value]!;
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ui.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Rating:${ui.rating}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                  ],
                                );
                              },
                              error: (error, stackTrace) =>
                                  Text(error.toString()),
                              loading: () => const CircularProgressIndicator()),
                    AsyncValue() => const CircularProgressIndicator(),
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
