import 'package:audioplayers/audioplayers.dart';
import 'package:darts_record_app/kv/login_user_id.dart';
import 'package:darts_record_app/model/user_info.dart';
import 'package:darts_record_app/page/common/user/user_profile_card.dart';
import 'package:darts_record_app/page/game/count_up.dart';
import 'package:darts_record_app/page/game/game_start.dart';
import 'package:darts_record_app/page/game/ui/darts_board.dart';
import 'package:darts_record_app/provider/player_list.dart';
import 'package:darts_record_app/provider/player_map.dart';
import 'package:darts_record_app/provider/user_info.dart';
import 'package:darts_record_app/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class ListPage extends ConsumerWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = AudioPlayer();
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
                    if (math.Random().nextBool()) {
                      player.play(AssetSource("yoro.mp3"));
                    } else {
                      player.play(AssetSource("saaiku.mp3"));
                    }
                    loadLoginUserId().then((value) {
                      ref.read(userInfoNotifierProvider).whenData((ui) {
                        int id = UserInfo.createMapfromList(ui)[value]!.id;
                        String name = UserInfo.createMapfromList(ui)[value]!.name;
                        // ユーザが追加登録されたとき参加プレイヤーリストに追加
                        ref.watch(playerListNotifierProvider.notifier).push(id);
                        ref.watch(playerMapNotifierProvider.notifier).addUser(id, name);
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CountUp()),
                    );
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
                      MaterialPageRoute(builder: (context) => DartsBoard()),
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
