import 'package:darts_record_app/page/game/ui/keyboard_button.dart';
import 'package:flutter/material.dart';

class CounterKeyboard extends StatelessWidget {
  const CounterKeyboard({super.key});

  @override
  Widget build(BuildContext context) {
    var _screenSize = MediaQuery.of(context).size;
    return Expanded(
        flex: 1,
        child: Center(
          child: Container(
            width: _screenSize.width,
            child: GridView.count(
              crossAxisCount: 5,
              children: [
                'S-BULL',
                'D-BULL',
                '20',
                '19',
                '18',
                '17',
                '16',
                '15',
                '14',
                '13',
                '12',
                '11',
                '10',
                '9',
                '8',
                '7',
                '6',
                '5',
                '4',
                '3',
                '2',
                '1',
                'Double',
                'Triple',
                'Cancel'
              ].map((key) {
                return GridTile(
                  child: KeyboardButton(key),
                );
              }).toList(),
            ),
          ),
        ));
  }
}
