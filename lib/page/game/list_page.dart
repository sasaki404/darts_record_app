import 'package:darts_record_app/page/game/count_up.dart';
import 'package:darts_record_app/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.darkGrey,
      body: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CountUp()),
              );
            },
            child: Card(
              color: AppColor.black,
              child: Text(
                'COUNT-UP',
                style:
                    GoogleFonts.bebasNeue(fontSize: 80, color: AppColor.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CountUp()),
              );
            },
            child: Card(
              color: AppColor.cyan,
              child: Text(
                '01GAME',
                style:
                    GoogleFonts.bebasNeue(fontSize: 80, color: AppColor.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CountUp()),
              );
            },
            child: Card(
              color: AppColor.red,
              child: Text(
                'BIG BULL',
                style:
                    GoogleFonts.bebasNeue(fontSize: 80, color: AppColor.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
