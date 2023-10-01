import 'package:darts_record_app/provider/counter_str.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class KeyboardButton extends ConsumerWidget {
  final String _value;
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
        final notifier = ref.read(counterStrNotifierProvider.notifier);
        notifier.updateState(_value);
      },
    ));
  }
}
