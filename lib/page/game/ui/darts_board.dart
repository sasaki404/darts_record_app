// ignore_for_file: library_private_types_in_public_api

import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:darts_record_app/page/game/ui/darts_board_painter.dart';
import 'package:darts_record_app/provider/counter_str.dart';
import 'package:darts_record_app/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DartsBoard extends ConsumerStatefulWidget {
  const DartsBoard({super.key});

  @override
  _DartsBoardWidgetState createState() => _DartsBoardWidgetState();
}

class _DartsBoardWidgetState extends ConsumerState<DartsBoard> {
  final List<int> tokuten = [
    11,
    14,
    9,
    12,
    5,
    20,
    1,
    18,
    4,
    13,
    6,
    10,
    15,
    2,
    17,
    3,
    19,
    7,
    16,
    8,
    11
  ];
  final diffAngle = (360 / 20) * (pi / 180);
  final double elevenEndAngle = -3;
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final double centerX = SizeConfig.blockSizeHorizontal! * 80;
    final double centerY = SizeConfig.blockSizeVertical! * 50;
    return GestureDetector(
      onTapUp: (TapUpDetails details) {
        // タップされた座標を取得
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final localPosition = renderBox.globalToLocal(details.globalPosition);

        // タップされた座標をダーツボードの中心からの距離と角度に変換
        final dx = localPosition.dx - centerX / 2;
        final dy = localPosition.dy - centerY / 2;
        final tapDistance = sqrt(dx * dx + dy * dy);
        final tapAngle = atan2(dy, dx);
        final radius = centerX / 2;
        print(tapDistance);

        // タップされたセクションの得点を計算
        final sectionIndex = ((tapAngle - elevenEndAngle) / diffAngle).floor();
        int score = tokuten[sectionIndex + 1];
        if (radius * 0.4468 <= tapDistance && tapDistance <= radius * 0.5513) {
          // トリプル
          score *= 3;
          player.play(AssetSource("triple.mp3"));
        } else if (radius * 0.8878 <= tapDistance && tapDistance <= radius) {
          // ダブル
          score *= 2;
          player.play(AssetSource("double.mp3"));
        } else if (radius * 0.058 <= tapDistance &&
            tapDistance <= radius * 0.15667) {
          score = 50;
          player.play(AssetSource("sbull.mp3"));
        } else if (tapDistance < radius * 0.058) {
          score = 50;
          player.play(AssetSource("dbull.mp3"));
        } else {
          player.play(AssetSource("bull.mp3"));
        }
        final notifier = ref.watch(counterStrNotifierProvider.notifier);
        notifier.updateState(score.toString());
      },
      child: CustomPaint(
        size: Size(centerX, centerY),
        painter: DartsBoardPainter(),
      ),
    );
  }

  // 座標からセクションのインデックスを計算
  int calculateSectionIndex(double x, double y, Size size) {
    // タップされた座標から中心までのベクトルの角度を計算
    double angle = atan2(y - size.height / 2, x - size.width / 2);

    // ラジアンから度数に変換し、0°から始まるように補正
    double degrees = (180 + angle * (180 / pi)) % 360;

    // セクションの数に応じてインデックスを計算
    int sectionIndex = ((degrees) % 360 / (360 / 20)).floor();

    return sectionIndex;
  }

  int getSectionScore(int sectionIndex) {
    // ここで各セクションの得点を返すロジックを実装
    return sectionIndex + 1;
    // ブルの場合は別途条件を追加
  }
}
