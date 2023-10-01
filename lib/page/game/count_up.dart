import 'package:darts_record_app/page/game/logic/calculator.dart';
import 'package:darts_record_app/page/game/ui/counter_keyboard.dart';
import 'package:darts_record_app/provider/counter_str.dart';
import 'package:darts_record_app/provider/round_number.dart';
import 'package:darts_record_app/provider/total_score.dart';
import 'package:darts_record_app/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CountUp extends ConsumerWidget {
  int tempScore = 0; // ダブル、トリプルを考慮するための一時変数
  int whatNum = 0; // ラウンドごとで今何投目か
  CountUp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalScore = ref.watch(totalScoreNotifierProvider);
    final roundNumber = ref.watch(roundNumberNotifierProvider);
    final totalScoreNotifier = ref.read(totalScoreNotifierProvider.notifier);
    final counterStrNotifier = ref.read(counterStrNotifierProvider.notifier);
    final roundNumberNotifier = ref.read(roundNumberNotifierProvider.notifier);
    ref.listen(counterStrNotifierProvider, (prevState, nextState) {
      if (nextState.startsWith('wait')) {
        return;
      }
      int prevScore = totalScore;
      int score = Calculator.toScore(nextState);
      if (score < 0) {
        tempScore = score;
      } else if (nextState.toUpperCase() == 'CANCEL' &&
          prevState != null &&
          prevState.startsWith('wait')) {
        totalScoreNotifier.updateState(int.parse(prevState.substring(5)));
        if (tempScore == 0 && whatNum == 0) {
          // ダブル、トリプル以外でラウンドの始まり
          whatNum = 2;
          roundNumberNotifier.toPrevRound();
        }
        if (tempScore == 0) {
          whatNum -= 1;
        }
        tempScore = 0;
      } else if (tempScore < 0 && !nextState.startsWith('wait')) {
        totalScoreNotifier.addScore(-tempScore * score);
        tempScore = 0;
        whatNum += 1;
      } else {
        totalScoreNotifier.addScore(score);
        whatNum += 1;
      }
      counterStrNotifier.updateState('wait:$prevScore');
      if (whatNum >= 3) {
        // ラウンド終了のとき
        roundNumberNotifier.toNextRound();
        whatNum = 0;
      }
    });
    return Scaffold(
      backgroundColor: AppColor.black,
      appBar: AppBar(
        title: Text(
          'COUNT-UP',
          style: GoogleFonts.bebasNeue(fontSize: 50, color: AppColor.black),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'ROUND $roundNumber/8',
            style: GoogleFonts.bebasNeue(color: AppColor.white, fontSize: 35),
          ),
          // 得点を表示
          Text(
            totalScore.toString(),
            style: GoogleFonts.bebasNeue(color: AppColor.white, fontSize: 120),
            textAlign: TextAlign.center,
          ),
          CounterKeyboard(),
        ],
      ),
    );
  }
}
