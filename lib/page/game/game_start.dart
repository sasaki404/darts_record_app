import 'package:darts_record_app/model/user_info.dart';
import 'package:darts_record_app/page/common/user/user_registration_dialog.dart';
import 'package:darts_record_app/page/game/count_up.dart';
import 'package:darts_record_app/page/game/zero_one_start.dart';
import 'package:darts_record_app/provider/login_user_id.dart';
import 'package:darts_record_app/provider/player_list.dart';
import 'package:darts_record_app/provider/player_map.dart';
import 'package:darts_record_app/provider/user_info.dart';
import 'package:darts_record_app/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

// ゲームの種類
enum GameType {
  countUpGame,
  zeroOneGame,
  cricketGame,
  rangeCountUpGame,
}

// スタート画面
class GameStart extends ConsumerWidget {
  final GameType gameType;
  const GameStart({super.key, required this.gameType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoNotifierProvider);
    final loginUserId = ref.watch(loginUserIdNotifierProvider);
    final playerMap = ref.watch(playerMapNotifierProvider);
    ref.listen(userInfoNotifierProvider, (prev, next) {
      next.whenData((value) {
        // ユーザが追加登録されたとき参加プレイヤーリストに追加
        ref.watch(playerListNotifierProvider.notifier).push(value.last.id);
        ref
            .watch(playerMapNotifierProvider.notifier)
            .addUser(value.last.id, value.last.name);
      });
    });
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
                  : (() {
                      List<Widget> userCardList = [];
                      for (var e in playerMap.entries) {
                        // ログインユーザを参加者リストに追加する
                        // ref.watch(playerListNotifierProvider.notifier).push(
                        //     UserInfo.createMapfromList(data)[value]!.name);
                        int userId = e.key;
                        String name = e.value;
                        userCardList.add(
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: const Text(
                                      "Remove this user?",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    actions: [
                                      GestureDetector(
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              top: 16,
                                              right: 8,
                                              bottom: 16,
                                              left: 16),
                                          child: const Text('No'),
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      GestureDetector(
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              top: 16,
                                              right: 8,
                                              bottom: 16,
                                              left: 16),
                                          child: const Text('Yes'),
                                        ),
                                        onTap: () {
                                          ref
                                              .watch(playerListNotifierProvider
                                                  .notifier)
                                              .remove(userId);
                                          ref
                                              .watch(playerMapNotifierProvider
                                                  .notifier)
                                              .remove(userId);
                                          // popだけだと画面が更新されない。とりあえず動作はOKだが要検討
                                          Navigator.pop(context);
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  GameStart(gameType: gameType),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.account_circle,
                                  size: 80,
                                  color: AppColor.white,
                                ),
                                Text(
                                  name,
                                  style: GoogleFonts.bebasNeue(
                                      fontSize: 20, color: AppColor.white),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Container(
                        padding: const EdgeInsets.all(20),
                        child: Wrap(
                          spacing: 30,
                          direction: Axis.horizontal,
                          children: userCardList,
                        ),
                      );
                    })(),
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
                          return Container(
                            color: AppColor.black,
                            child: ListView(children: [
                              UserRegistrationDialog(
                                isEditMode: false,
                                isLogin: false,
                              ),
                              userInfo.when(
                                // whenメソッドでAsyncValueを使用
                                data: (data) {
                                  List<Widget> userCardList = [];
                                  for (UserInfo info in data) {
                                    // readだとCountUpに行ったときにリセットされる
                                    userCardList.add(
                                      TextButton(
                                        onPressed: () {
                                          // 参加プレイヤーに追加
                                          ref
                                              .watch(playerListNotifierProvider
                                                  .notifier)
                                              .push(info.id);
                                          ref
                                              .watch(playerMapNotifierProvider
                                                  .notifier)
                                              .addUser(info.id, info.name);
                                          Navigator.pop(context);
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  GameStart(gameType: gameType),
                                            ),
                                          );
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.account_circle,
                                              size: 80,
                                              color: AppColor.white,
                                            ),
                                            Text(
                                              info.name,
                                              style: GoogleFonts.bebasNeue(
                                                fontSize: 20,
                                                color: AppColor.white,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                            Text(
                                              "Rating:${info.rating}",
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                                color: AppColor.white,
                                                decoration: TextDecoration.none,
                                              ),
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  return Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Wrap(
                                      spacing: 30,
                                      direction: Axis.horizontal,
                                      children: userCardList,
                                    ),
                                  );
                                },
                                error: (error, stackTrace) =>
                                    Text(error.toString()),
                                loading: () =>
                                    const CircularProgressIndicator(),
                              ),
                            ]),
                          );
                        });
                  },
                  child: const Icon(
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
                        case GameType.zeroOneGame:
                          return ZeroOneStart();
                        case _:
                          return CountUp();
                      }
                    },
                  ),
                );
              },
              child: Card(
                color: const Color.fromARGB(255, 183, 2, 2),
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
