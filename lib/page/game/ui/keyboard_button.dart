import 'package:darts_record_app/provider/counter_str.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math' as math;

class KeyboardButton extends ConsumerWidget {
  final String _value;
  final player = AudioPlayer();
  KeyboardButton(this._value);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        child: TextButton(
      style: TextButton.styleFrom(
        fixedSize: const Size(30, 30), // 幅,高さ
      ),
      child: Center(
        child: Text(
          _value,
          style: GoogleFonts.bebasNeue(
            fontSize: 25,
            color: Colors.white,
          ),
        ),
      ),
      onPressed: () {
        final val = _value.toUpperCase();
        if (val == "S-BULL") {
          player.play(AssetSource("sbull.mp3"));
        } else if (val == "D-BULL") {
          player.play(AssetSource("dbull.mp3"));
        } else if (val == "NEXT") {
          player.play(AssetSource("next.mp3"));
        } else if (val == "CANCEL") {
          player.play(AssetSource("cancel.mp3"));
        } else if (val == "DOUBLE") {
          player.play(AssetSource("double.mp3"));
        } else if (val == "TRIPLE") {
          player.play(AssetSource("triple.mp3"));
        } else {
          if (math.Random().nextBool()) {
            player.play(AssetSource("bull.mp3"));
          } else {
            player.play(AssetSource("ei.mp3"));
          }
        }
        final notifier = ref.read(counterStrNotifierProvider.notifier);
        notifier.updateState(_value);
      },
    ));
  }
}
