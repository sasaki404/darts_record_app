import 'package:darts_record_app/kv/login_user_id.dart';
import 'package:darts_record_app/model/user_info.dart';
import 'package:darts_record_app/page/common/user/user_profile_card.dart';
import 'package:darts_record_app/page/game/game_start.dart';
import 'package:darts_record_app/provider/player_list.dart';
import 'package:darts_record_app/provider/player_map.dart';
import 'package:darts_record_app/provider/user_info.dart';
import 'package:darts_record_app/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ListPage extends ConsumerWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColor.darkGrey,
      body: Column(
        children: [
          UserProfileCard(),
          Expanded(
            child: ListView(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    loadLoginUserId().then((value) {
                      ref.read(userInfoNotifierProvider).whenData((ui) {
                        int id = UserInfo.createMapfromList(ui)[value]!.id;
                        String name =
                            UserInfo.createMapfromList(ui)[value]!.name;
                        // ユーザが追加登録されたとき参加プレイヤーリストに追加
                        ref.watch(playerListNotifierProvider.notifier).push(id);
                        ref
                            .watch(playerMapNotifierProvider.notifier)
                            .addUser(id, name);
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GameStart(
                                gameType: GameType.countUpGame)),
                      );
                    });
                  },
                  child: Card(
                    color: AppColor.black,
                    child: Text(
                      'COUNT-UP',
                      style: GoogleFonts.bebasNeue(
                          fontSize: 80, color: AppColor.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    loadLoginUserId().then((value) {
                      ref.read(userInfoNotifierProvider).whenData((ui) {
                        int id = UserInfo.createMapfromList(ui)[value]!.id;
                        String name =
                            UserInfo.createMapfromList(ui)[value]!.name;
                        // ユーザが追加登録されたとき参加プレイヤーリストに追加
                        ref.watch(playerListNotifierProvider.notifier).push(id);
                        ref
                            .watch(playerMapNotifierProvider.notifier)
                            .addUser(id, name);
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GameStart(
                                gameType: GameType.zeroOneGame)),
                      );
                    });
                  },
                  child: Card(
                    color: AppColor.cyan,
                    child: Text(
                      '01GAME',
                      style: GoogleFonts.bebasNeue(
                          fontSize: 80, color: AppColor.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const GameStart(gameType: GameType.zeroOneGame)),
                    );
                  },
                  child: Card(
                    color: AppColor.red,
                    child: Text(
                      'cricket',
                      style: GoogleFonts.bebasNeue(
                          fontSize: 80, color: AppColor.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
