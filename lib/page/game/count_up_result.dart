import 'package:audioplayers/audioplayers.dart';
import 'package:darts_record_app/page/game/count_up.dart';
import 'package:darts_record_app/page/home_page.dart';
import 'package:darts_record_app/provider/counter_str.dart';
import 'package:darts_record_app/provider/is_finished.dart';
import 'package:darts_record_app/provider/player_list.dart';
import 'package:darts_record_app/provider/player_map.dart';
import 'package:darts_record_app/provider/round_number.dart';
import 'package:darts_record_app/provider/score_list.dart';
import 'package:darts_record_app/provider/total_score.dart';
import 'package:darts_record_app/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CountUpResult extends ConsumerWidget {
  CountUpResult({super.key});
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerList = ref.watch(playerListNotifierProvider);
    final playerMap = ref.watch(playerMapNotifierProvider);
    final totalScore = ref.read(totalScoreNotifierProvider);
    List<Widget> resultList = [];
    for (var playerId in playerList) {
      double score = totalScore[playerId]! / 8;
      resultList.add(
        Column(
          children: [
            Text(playerMap[playerId]!,
                style: GoogleFonts.bebasNeue(
                  color: AppColor.black,
                  fontSize: 30,
                )),
            Text(
              totalScore[playerId].toString(),
              style: GoogleFonts.bebasNeue(color: AppColor.black, fontSize: 60),
            ),
            Text(
              "STATS : $score",
              style: GoogleFonts.bebasNeue(color: AppColor.black, fontSize: 20),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      body: Column(
        children: [
          Text("RESULT",
              style:
                  GoogleFonts.bebasNeue(color: AppColor.black, fontSize: 50)),
          const SizedBox(height: 60),
          Wrap(
            spacing: 30,
            children: resultList,
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    player.play(AssetSource("home.mp3"));
                    final totalScoreNotifier =
                        ref.read(totalScoreNotifierProvider.notifier);
                    final scoreListNotifier =
                        ref.read(scoreListNotifierProvider.notifier);
                    final roundNumberNotifier =
                        ref.read(roundNumberNotifierProvider.notifier);
                    final isFinishedNotifer =
                        ref.read(isFinishedNotifierProvider.notifier);
                    final countStrNotifier =
                        ref.read(counterStrNotifierProvider.notifier);
                    for (var s in playerList) {
                      totalScoreNotifier.updateState(s, 0);
                    }
                    roundNumberNotifier.updateState(1);
                    isFinishedNotifer.updateState(false);
                    countStrNotifier.updateState('wait-result');
                    scoreListNotifier.clean();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      (route) => false, // すべての履歴をクリア
                    );
                  },
                  child: Text("HOME",
                      style: GoogleFonts.bebasNeue(
                          color: AppColor.black, fontSize: 30))),
              const SizedBox(
                height: 30,
                width: 30,
              ),
              ElevatedButton(
                  onPressed: () {
                    player.play(AssetSource("yoro.mp3"));
                    final totalScoreNotifier =
                        ref.read(totalScoreNotifierProvider.notifier);
                    final scoreListNotifier =
                        ref.read(scoreListNotifierProvider.notifier);
                    final roundNumberNotifier =
                        ref.read(roundNumberNotifierProvider.notifier);
                    final isFinishedNotifer =
                        ref.read(isFinishedNotifierProvider.notifier);
                    final countStrNotifier =
                        ref.read(counterStrNotifierProvider.notifier);
                    for (var s in playerList) {
                      totalScoreNotifier.updateState(s, 0);
                    }
                    roundNumberNotifier.updateState(1);
                    isFinishedNotifer.updateState(false);
                    countStrNotifier.updateState('wait-result');
                    scoreListNotifier.clean();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => CountUp()),
                      (route) => false, // すべての履歴をクリア
                    );
                  },
                  child: Text("CONTINUE",
                      style: GoogleFonts.bebasNeue(
                          color: AppColor.black, fontSize: 30))),
            ],
          )
        ],
      ),
    );
  }
}
