import 'package:darts_record_app/model/user_info.dart';
import 'package:darts_record_app/page/common/user/user_registration_dialog.dart';
import 'package:darts_record_app/page/game/count_up.dart';
import 'package:darts_record_app/provider/login_user_id.dart';
import 'package:darts_record_app/provider/player_list.dart';
import 'package:darts_record_app/provider/user_info.dart';
import 'package:darts_record_app/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

// ゲームの種類
enum GameType {
  countUpGame,
  zeroOneGame,
  bigBullGame,
  cricketGame,
  centerCountUpGame,
}

// スタート画面
class GameStart extends ConsumerWidget {
  final GameType gameType;
  const GameStart({super.key, required this.gameType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoNotifierProvider);
    final loginUserId = ref.watch(loginUserIdNotifierProvider);
    return Scaffold(
        backgroundColor: AppColor.black,
        appBar: AppBar(
          title: Text(
            'ADD PLAYER',
            style: GoogleFonts.bebasNeue(fontSize: 50, color: AppColor.black),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            switch (loginUserId) {
              AsyncData(:final value) => (value == -1) // ログインしているユーザがいないとき
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
                        List<Widget> userCardList = [];
                        for (UserInfo info in data) {
                          // readだとCountUpに行ったときにリセットされる
                          ref
                              .watch(playerListNotifierProvider.notifier)
                              .push(info.name);
                          userCardList.add(Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.account_circle,
                                    size: 80,
                                    color: AppColor.white,
                                  ),
                                  Text(
                                    info.name,
                                    style: GoogleFonts.bebasNeue(
                                        fontSize: 20, color: AppColor.white),
                                  ),
                                  Text(
                                    "Rating:${info.rating}",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        color: AppColor.white),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 40,
                              ),
                            ],
                          ));
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: userCardList,
                        );
                      },
                      error: (error, stackTrace) => Text(error.toString()),
                      loading: () => const CircularProgressIndicator()),
              AsyncValue() => const CircularProgressIndicator(),
            },
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return UserRegistrationDialog(
                            // すでにログインしているユーザがいるときは編集モード
                            isEditMode: false,
                            isLogin: false,
                          );
                        });
                  },
                  child: Icon(
                    Icons.add_box,
                    size: 80,
                    color: AppColor.white,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      switch (gameType) {
                        case GameType.countUpGame:
                          return CountUp();
                        case _:
                          return CountUp();
                      }
                    },
                  ),
                );
              },
              child: Card(
                color: Color.fromARGB(255, 183, 2, 2),
                child: Text(
                  'GAME START!',
                  style: GoogleFonts.bebasNeue(
                      fontSize: 40, color: AppColor.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ));
  }
}
