import 'package:audioplayers/audioplayers.dart';
import 'package:darts_record_app/page/game/count_up.dart';
import 'package:darts_record_app/page/game/list_page.dart';
import 'package:darts_record_app/provider/counter_str.dart';
import 'package:darts_record_app/provider/is_finished.dart';
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
    final totalScore = ref.read(totalScoreNotifierProvider);
    final totalScoreNotifier = ref.read(totalScoreNotifierProvider.notifier);
    final scoreListNotifier = ref.read(scoreListNotifierProvider.notifier);
    final roundNumberNotifier = ref.read(roundNumberNotifierProvider.notifier);
    final isFinishedNotifer = ref.read(isFinishedNotifierProvider.notifier);
    final countStrNotifier = ref.read(counterStrNotifierProvider.notifier);
    double score = totalScore / 8;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 60),
          Text("RESULT",
              style:
                  GoogleFonts.bebasNeue(color: AppColor.black, fontSize: 50)),
          Text(totalScore.toString(),
              style:
                  GoogleFonts.bebasNeue(color: AppColor.black, fontSize: 120)),
          Text("STATS : $score",
              style:
                  GoogleFonts.bebasNeue(color: AppColor.black, fontSize: 40)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    player.play(AssetSource("home.mp3"));
                    totalScoreNotifier.updateState(0);
                    roundNumberNotifier.updateState(1);
                    isFinishedNotifer.updateState(false);
                    countStrNotifier.updateState('');
                    scoreListNotifier.clean();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListPage()),
                    );
                  },
                  child: Text("HOME",
                      style: GoogleFonts.bebasNeue(
                          color: AppColor.black, fontSize: 30))),
              const SizedBox(
                width: 30,
              ),
              ElevatedButton(
                  onPressed: () {
                    player.play(AssetSource("yoro.mp3"));
                    totalScoreNotifier.updateState(0);
                    roundNumberNotifier.updateState(1);
                    isFinishedNotifer.updateState(false);
                    countStrNotifier.updateState('');
                    scoreListNotifier.clean();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CountUp()),
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
