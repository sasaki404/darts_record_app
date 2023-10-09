import 'package:audioplayers/audioplayers.dart';
import 'package:darts_record_app/database/count_up_record_db.dart';
import 'package:darts_record_app/page/game/count_up_result.dart';
import 'package:darts_record_app/page/game/logic/calculator.dart';
import 'package:darts_record_app/page/game/ui/counter_keyboard.dart';
import 'package:darts_record_app/provider/counter_str.dart';
import 'package:darts_record_app/provider/is_finished.dart';
import 'package:darts_record_app/provider/round_number.dart';
import 'package:darts_record_app/provider/round_score.dart';
import 'package:darts_record_app/provider/score_list.dart';
import 'package:darts_record_app/provider/total_score.dart';
import 'package:darts_record_app/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CountUp extends ConsumerWidget {
  CountUp({super.key});
  int tempScore = 0; // ダブル、トリプルを考慮するための一時変数
  int whatNum = 0; // ラウンドごとで今何投目か
  final player = AudioPlayer();
  final countUpRecordDB = CountUpRecordDB();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalScore = ref.watch(totalScoreNotifierProvider);
    final roundNumber = ref.watch(roundNumberNotifierProvider);
    // final roundScore = ref.watch(roundScoreNotifierProvider);
    // final scoreList = ref.watch(scoreListNotifierProvider);
    final isFinished = ref.watch(isFinishedNotifierProvider);
    final totalScoreNotifier = ref.watch(totalScoreNotifierProvider.notifier);
    final counterStrNotifier = ref.watch(counterStrNotifierProvider.notifier);
    final roundNumberNotifier = ref.watch(roundNumberNotifierProvider.notifier);
    final scoreListNotifier = ref.watch(scoreListNotifierProvider.notifier);
    print('scoreListNotifierProvider: ${ref.watch(scoreListNotifierProvider)}');
    final roundScoreNotifier = ref.watch(roundScoreNotifierProvider.notifier);
    final isFinishedNotifier = ref.watch(isFinishedNotifierProvider.notifier);
    ref.listen(counterStrNotifierProvider, (prevState, nextState) {
      if (nextState.startsWith('wait') || roundNumber > 8) {
        if (nextState == 'wait-result') {
          tempScore = 0;
          whatNum = 0;
        }
        return;
      }
      int prevScore = totalScore;
      int score = Calculator.toScore(nextState);
      if (score < 0) {
        // ダブルかトリプルのコマンド
        tempScore = score;
      } else if (nextState.toUpperCase() == 'CANCEL' &&
          prevState != null &&
          prevState.startsWith('wait')) {
        // キャンセルボタンが押されて、Redoスタックがあるとき
        if (tempScore >= 0) {
          scoreListNotifier.pop();
          totalScoreNotifier.updateState(scoreListNotifier.sum());
        }
        if (tempScore == 0 && whatNum == 0) {
          // ダブル、トリプル以外でラウンドの始まり
          whatNum = 2;
          roundNumberNotifier.toPrevRound();
        }
        if (tempScore == 0) {
          // ダブルトリプル以外
          whatNum -= 1;
        }
        tempScore = 0;
      } else if (tempScore < 0 && !nextState.startsWith('wait')) {
        // 1個前にダブルかトリプルが選択されてスコアを選択したとき
        final cnt = -tempScore * score;
        totalScoreNotifier.addScore(cnt);
        scoreListNotifier.push(cnt);
        tempScore = 0;
        whatNum += 1;
      } else if (nextState == "Next") {
        whatNum = 3;
      } else {
        // 普通にシングルのスコア
        totalScoreNotifier.addScore(score);
        scoreListNotifier.push(score);
        whatNum += 1;
      }
      if (roundNumber >= 8 && whatNum >= 3) {
        // ゲーム終了できるとき
        isFinishedNotifier.updateState(true);
        return;
      }
      // 二連ちゃんで同じスコアだったらリスナーがスコアの選択を検知できんからステートを更新しとる
      counterStrNotifier.updateState('wait:$prevScore');
      if (whatNum >= 3) {
        // ラウンド終了のとき
        roundNumberNotifier.updateState(roundNumber + 1);
        whatNum = 0;
        roundScoreNotifier.clean();
        player.play(AssetSource("next.mp3"));
      }
    });
    // ref.listen(scoreListNotifierProvider, (prevState, nextState) {
    //   if (nextState.length <= 3 * (roundNumber - 1)) {
    //     return;
    //   }
    //   for (int i = 3 * (roundNumber - 1); i < nextState.length; i++) {
    //     roundScoreNotifier.push(nextState[i]);
    //   }
    // });
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
            (roundNumber <= 8) ? 'ROUND $roundNumber/8' : 'ROUND 8/8',
            style: GoogleFonts.bebasNeue(color: AppColor.white, fontSize: 35),
          ),
          // 得点を表示
          Text(
            totalScore.toString(),
            style: GoogleFonts.bebasNeue(color: AppColor.white, fontSize: 120),
            textAlign: TextAlign.center,
          ),
          isFinished
              ? ElevatedButton(
                  onPressed: () async {
                    player.play(AssetSource("result.mp3"));
                    final score = ref.read(totalScoreNotifierProvider);
                    final scoreList = ref.read(scoreListNotifierProvider);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CountUpResult()),
                    );
                    // TODO:  マルチプレイ対応でuserIdをちゃんと指定する。スコアとかのstateも辞書型に変更してid:stateみたいな感じに
                    // レコード保存
                    await countUpRecordDB.insert(
                        userId: 1, score: score, scoreList: scoreList);
                  },
                  child: Text("Finish",
                      style: GoogleFonts.bebasNeue(
                          color: AppColor.black, fontSize: 30)))
              : const SizedBox(),
          // Row(
          //   children: roundScore
          //       .map((e) => Text(
          //             e.toString(),
          //             style: GoogleFonts.bebasNeue(
          //                 color: AppColor.white, fontSize: 20),
          //           ))
          //       .toList(),
          // ),
          CounterKeyboard(),
        ],
      ),
    );
  }
}
