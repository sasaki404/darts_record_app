// ignore_for_file: library_private_types_in_public_api

import 'dart:math';
import 'package:darts_record_app/page/game/ui/darts_board_painter.dart';
import 'package:darts_record_app/util/app_color.dart';
import 'package:darts_record_app/util/size_config.dart';
import 'package:flutter/material.dart';

class DartsBoard extends StatelessWidget {
  const DartsBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: DartsBoardWidget(),
      ),
    );
  }
}

class DartsBoardWidget extends StatefulWidget {
  const DartsBoardWidget({super.key});

  @override
  _DartsBoardWidgetState createState() => _DartsBoardWidgetState();
}

class _DartsBoardWidgetState extends State<DartsBoardWidget> {
  int? tappedSectionScore;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final double centerX = SizeConfig.blockSizeHorizontal! * 80;
    final double centerY = SizeConfig.blockSizeVertical! * 50;
    const diffAngle = (360 / 20) * (pi / 180);
    print(diffAngle);
    final double elevenEndAngle = -3;
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
        print(tapAngle - elevenEndAngle);

        // タップされたセクションの得点を計算
        final sectionIndex = ((tapAngle - elevenEndAngle) / diffAngle).floor();
        print(tapAngle);
        final tappedSectionScore = sectionIndex + 1;

        // タップされたセクションに対する処理を行う
        print('タップされたセクション: $tappedSectionScore');
      },
      child: CustomPaint(
        size: Size(SizeConfig.blockSizeHorizontal! * 80,
            SizeConfig.blockSizeVertical! * 50),
        painter: DartsBoardPainter(tappedSectionScore),
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
