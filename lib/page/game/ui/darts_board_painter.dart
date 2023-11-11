import 'dart:math';
import 'package:darts_record_app/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DartsBoardPainter extends CustomPainter {
  DartsBoardPainter(int? tappedSectionScore);
  final displayScoreStrList = [
    "17",
    "3",
    "19",
    "7",
    "16",
    "8",
    "11",
    "14",
    "9",
    "12",
    "5",
    "20",
    "1",
    "18",
    "4",
    "13",
    "6",
    "10",
    "15",
    "2",
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColor.black
      ..style = PaintingStyle.fill;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double boardRadius = size.width / 2;

    // ダーツボードの外側の円を描画
    canvas.drawCircle(Offset(centerX, centerY), boardRadius, paint);

    // ダーツボードのセクションを描画
    final sectionPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black
      ..strokeWidth = 10;

    const sectionCount = 20;
    const angle = 360 / sectionCount;

    for (int i = 0; i < sectionCount; i++) {
      final startAngle = i * angle * (pi / 180) + 30;
      // final endAngle = (i + 1) * angle * (pi / 180)

      // ダブルリングを描画
      if (i % 2 != 0) {
        sectionPaint.color = AppColor.black;
        final doubleRingPaint = Paint()
          ..color = Colors.red
          ..style = PaintingStyle.stroke
          ..strokeWidth = 20.0;
        canvas.drawArc(
          Rect.fromCircle(
              center: Offset(centerX, centerY), radius: boardRadius * 0.95),
          startAngle,
          angle * (pi / 180),
          false,
          doubleRingPaint,
        );
      } else {
        sectionPaint.color = Colors.white;
        final doubleRingPaint = Paint()
          ..color = AppColor.blue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 20.0;
        canvas.drawArc(
          Rect.fromCircle(
              center: Offset(centerX, centerY), radius: boardRadius * 0.95),
          startAngle,
          angle * (pi / 180),
          false,
          doubleRingPaint,
        );
      }

      // セクションの弧を描画
      final path = Path();
      path.moveTo(centerX, centerY);
      path.arcTo(
        Rect.fromCircle(
            center: Offset(centerX, centerY), radius: boardRadius * 0.9),
        startAngle,
        angle * (pi / 180),
        false,
      );
      path.lineTo(centerX, centerY);

      // セクションの数字を上に表示
      final textX =
          centerX + (boardRadius * 1.1) * cos(startAngle + (angle - 0.1) / 2);
      final textY =
          centerY + (boardRadius * 1.1) * sin(startAngle + (angle - 0.05) / 2);
      final sectionText = displayScoreStrList[i];
      // 数字を描画
      final textPainter = TextPainter(
        text: TextSpan(
            text: sectionText,
            style: GoogleFonts.bebasNeue(fontSize: 20, color: AppColor.black)),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout(minWidth: 0, maxWidth: size.width);
      textPainter.paint(canvas, Offset(textX - 5, textY - 10)); // 数字を中心に描画

      canvas.drawPath(path, sectionPaint);
    }

    // トリプルリングの描画
    for (int i = 0; i < sectionCount; i++) {
      final startAngle = i * angle * (pi / 180) + 30;
      if (i % 2 == 0) {
        final tripleRingPaint = Paint()
          ..color = AppColor.blue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 12.0;
        canvas.drawArc(
          Rect.fromCircle(
              center: Offset(centerX, centerY), radius: boardRadius * 0.5),
          startAngle,
          angle * (pi / 180),
          false,
          tripleRingPaint,
        );
      } else {
        final tripleRingPaint = Paint()
          ..color = Colors.red
          ..style = PaintingStyle.stroke
          ..strokeWidth = 12.0;
        canvas.drawArc(
          Rect.fromCircle(
              center: Offset(centerX, centerY), radius: boardRadius * 0.5),
          startAngle,
          angle * (pi / 180),
          false,
          tripleRingPaint,
        );
      }
    }
    paint.color = Colors.red;
    // ブル（シングル）を描画
    canvas.drawCircle(Offset(centerX, centerY), boardRadius * 0.15, paint);
    paint.color = Colors.black;
    // ブル（ダブル）を描画
    canvas.drawCircle(Offset(centerX, centerY), boardRadius * 0.05, paint);
  }

  // 再描画の条件を指定する
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
