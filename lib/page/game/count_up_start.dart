// カウントアップの開始準備
// プレイヤーの追加
// 参加プレイヤーをString[]のstateとして保持
// DBにプレイヤー保存して、次回から1タップでplayer選択できるように
import 'package:darts_record_app/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CountUpStart extends ConsumerWidget {
  const CountUpStart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          children: [
            Text(
              "ADD PLAYER",
              style: GoogleFonts.bebasNeue(color: AppColor.white, fontSize: 35),
            ),
            
          ],
        ));
  }
}
