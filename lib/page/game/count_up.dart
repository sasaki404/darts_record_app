import 'package:audioplayers/audioplayers.dart';
import 'package:darts_record_app/database/count_up_record_table.dart';
import 'package:darts_record_app/database/user_info_table.dart';
import 'package:darts_record_app/page/game/count_up_result.dart';
import 'package:darts_record_app/page/game/logic/calculator.dart';
import 'package:darts_record_app/page/game/ui/counter_keyboard.dart';
import 'package:darts_record_app/page/game/ui/darts_board.dart';
import 'package:darts_record_app/provider/counter_str.dart';
import 'package:darts_record_app/provider/current_player_index.dart';
import 'package:darts_record_app/provider/is_darts_board_display.dart';
import 'package:darts_record_app/provider/is_finished.dart';
import 'package:darts_record_app/provider/is_selected.dart';
import 'package:darts_record_app/provider/player_list.dart';
import 'package:darts_record_app/provider/round_number.dart';
import 'package:darts_record_app/provider/score_list.dart';
import 'package:darts_record_app/provider/total_score.dart';
import 'package:darts_record_app/util/app_color.dart';
import 'package:darts_record_app/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CountUp extends ConsumerWidget {
  CountUp({super.key});
  int tempScore = 0; // ダブル、トリプルを考慮するための一時変数
  int whatNum = 0; // ラウンドごとで今何投目か
  final audioPlayer = AudioPlayer();
  final countUpRecordTable = CountUpRecordTable();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SizeConfig().init(context);
    // State
    final totalScore = ref.watch(totalScoreNotifierProvider);
    final roundNumber = ref.watch(roundNumberNotifierProvider);
    // final roundScore = ref.watch(roundScoreNotifierProvider);
    // final scoreList = ref.watch(scoreListNotifierProvider);
    final isFinished = ref.watch(isFinishedNotifierProvider);
    final isDartBoardDisplay = ref.watch(isDartsBoardDisplayNotifierProvider);
    final playerList = ref.watch(playerListNotifierProvider);
    final currentPlayerIndex = ref.watch(currentPlayerIndexNotifierProvider);

    // Notifier
    final totalScoreNotifier = ref.watch(totalScoreNotifierProvider.notifier);
    final counterStrNotifier = ref.watch(counterStrNotifierProvider.notifier);
    final roundNumberNotifier = ref.watch(roundNumberNotifierProvider.notifier);
    final scoreListNotifier = ref.watch(scoreListNotifierProvider.notifier);
    final isSelectedNotifier = ref.watch(isSelectedNotifierProvider.notifier);
    // print('scoreListNotifierProvider: ${ref.watch(scoreListNotifierProvider)}');
    // TODO:ラウンドでn投目のスコアを表示させたいときに使う
    // final roundScoreNotifier = ref.watch(roundScoreNotifierProvider.notifier);
    final isFinishedNotifier = ref.watch(isFinishedNotifierProvider.notifier);
    final isDartsBoardDisplayNotifier =
        ref.watch(isDartsBoardDisplayNotifierProvider.notifier);
    final currentPlayerIndexNofiter =
        ref.watch(currentPlayerIndexNotifierProvider.notifier);

    // 得点の入力イベントのコールバック
    ref.listen(counterStrNotifierProvider, (prevState, nextState) {
      // TODO: 'wait'、'wait-result'は定数定義クラスを別で作成してそこで定数化するべき
      if (nextState.startsWith('wait') || roundNumber > 8) {
        // 'wait-resulth'はリザルト画面でボタンを押したときに設定される
        if (nextState == 'wait-result') {
          tempScore = 0;
          whatNum = 0;
        }
        return;
      }

      String player = playerList[currentPlayerIndex];
      // スコアの計算
      int prevScore = (totalScore[player] != null) ? totalScore[player]! : 0;
      int score = Calculator.toScore(nextState);
      if (score < 0) {
        // ダブルかトリプルのコマンド
        tempScore = score;
      } else if (nextState.toUpperCase() == 'CANCEL' &&
          prevState != null &&
          prevState.startsWith('wait')) {
        // キャンセルボタンが押されたとき

        // n-1投目にする
        whatNum -= 1;
        if (whatNum == -1) {
          if (roundNumber == 1) {
            whatNum = 0;
          } else {
            // ラウンドの始まり
            whatNum = 2;
            roundNumberNotifier.toPrevRound();
          }
        }

        if (tempScore >= 0) {
          // Redoスタックの先頭にスコアがあるとき
          scoreListNotifier.pop(player);
          totalScoreNotifier.updateState(player, scoreListNotifier.sum(player));
        }
        tempScore = 0;
      } else if (tempScore < 0 && !nextState.startsWith('wait')) {
        // 1個前にダブルかトリプルが選択されてスコアを選択したとき
        final cnt = -tempScore * score;
        totalScoreNotifier.addScore(player, cnt);
        scoreListNotifier.push(player, cnt);
        tempScore = 0;
        whatNum += 1;
      } else if (nextState == "Next") {
        whatNum = 3;
      } else {
        // 普通にシングルのスコア
        totalScoreNotifier.addScore(player, score);
        scoreListNotifier.push(player, score);
        whatNum += 1;
      }
      // 得点を即時反映させるための処理。もっと良い方法があるはず
      isSelectedNotifier.updateState();

      // 二連続で同じスコアだったらリスナーがスコアの選択を検知でないから待機状態ステートに更新
      counterStrNotifier.updateState('wait:$prevScore');

      // 3回投げたとき
      if (whatNum >= 3) {
        bool isFinishRound = !(currentPlayerIndex + 1 < playerList.length);
        currentPlayerIndexNofiter
            .updateState((isFinishRound) ? 0 : currentPlayerIndex + 1);

        if (roundNumber >= 8 && isFinishRound) {
          // ゲーム終了できるとき
          isFinishedNotifier.updateState(true);
          return;
        }

        if (isFinishRound) {
          // ラウンド終了のとき
          roundNumberNotifier.updateState(roundNumber + 1);
          audioPlayer.play(AssetSource("next.mp3"));
        }
        whatNum = 0;
        // roundScoreNotifier.clean();
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
        centerTitle: true,
        title: Text(
          'COUNT-UP',
          style: GoogleFonts.bebasNeue(fontSize: 50, color: AppColor.black),
          textAlign: TextAlign.center,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.repeat),
            onPressed: () =>
                {isDartsBoardDisplayNotifier.updateState(!isDartBoardDisplay)},
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // ラウンド数を表示
          Text(
            (roundNumber <= 8) ? 'ROUND $roundNumber/8' : 'ROUND 8/8',
            style: GoogleFonts.bebasNeue(color: AppColor.white, fontSize: 35),
          ),

          // プレイヤーごとにスコアを表示
          (() {
            // 得点を即時反映させるための処理。もっと良い方法があるはず
            ref.watch(isSelectedNotifierProvider);
            List<Widget> playerScoreDisplayList = [];
            print('playerList:${playerList}');
            int index = 0;
            for (var e in playerList) {
              playerScoreDisplayList.add(
                Column(
                  children: [
                    // プレイヤー名を表示
                    Text(
                      e,
                      style: GoogleFonts.bebasNeue(
                          color: (currentPlayerIndex == index)
                              ? AppColor.red
                              : AppColor.white,
                          fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    // 得点を表示
                    Text(
                      (totalScore[e] != null) ? totalScore[e].toString() : '0',
                      style: GoogleFonts.bebasNeue(
                          color: AppColor.white, fontSize: 60),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
              index += 1;
            }
            return Wrap(
              spacing: 100,
              children: playerScoreDisplayList,
            );
          })(),

          // 終了したとき
          isFinished
              ? ElevatedButton(
                  onPressed: () async {
                    audioPlayer.play(AssetSource("result.mp3"));
                    final score = ref.read(totalScoreNotifierProvider);
                    final scoreList = ref.read(scoreListNotifierProvider);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CountUpResult()),
                    );
                    // TODO:  マルチプレイ対応でuserIdをちゃんと指定する。スコアとかのstateも辞書型に変更してid:stateみたいな感じに
                    // レコード保存
                    for (var name in playerList) {
                      int id = await UserInfoTable().selectIdByName(name);
                      await countUpRecordTable.insert(
                          userId: id,
                          score: score[name]!,
                          scoreList: scoreList[name]!);
                    }
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
          SizedBox(
            height: SizeConfig.blockSizeVertical! * 5,
          ),
          // 得点入力
          isDartBoardDisplay ? Center(child: DartsBoard()) : CounterKeyboard(),
          SizedBox(
            height: SizeConfig.blockSizeVertical! * 7,
          ),
          isDartBoardDisplay
              ? ElevatedButton(
                  onPressed: () {
                    audioPlayer.play(AssetSource("cancel.mp3"));
                    counterStrNotifier.updateState("CANCEL");
                  },
                  child: Text("CANCEL",
                      style: GoogleFonts.bebasNeue(
                          color: AppColor.black, fontSize: 15)))
              : SizedBox(),
        ],
      ),
    );
  }
}
