import 'package:darts_record_app/page/game/zero_one.dart';
import 'package:darts_record_app/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ZeroOneStart extends ConsumerWidget {
  const ZeroOneStart({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColor.black,
      appBar: AppBar(
        title: Text(
          'SELECT MODE',
          style: GoogleFonts.bebasNeue(fontSize: 50, color: AppColor.black),
        ),
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ZeroOne(gameScore: 301)),
              );
            },
            child: Card(
              color: const Color.fromARGB(255, 0, 203, 122),
              child: Text(
                '301',
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
                MaterialPageRoute(
                    builder: (context) => ZeroOne(gameScore: 501)),
              );
            },
            child: Card(
              color: AppColor.cyan,
              child: Text(
                '501',
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
                MaterialPageRoute(
                    builder: (context) => ZeroOne(gameScore: 701)),
              );
            },
            child: Card(
              color: AppColor.red,
              child: Text(
                '701',
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
                MaterialPageRoute(
                    builder: (context) => ZeroOne(gameScore: 901)),
              );
            },
            child: Card(
              color: Color.fromARGB(255, 8, 74, 230),
              child: Text(
                '901',
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
                MaterialPageRoute(
                    builder: (context) => ZeroOne(gameScore: 1101)),
              );
            },
            child: Card(
              color: Color.fromARGB(255, 35, 40, 52),
              child: Text(
                '1101',
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
                MaterialPageRoute(
                    builder: (context) => ZeroOne(gameScore: 1501)),
              );
            },
            child: Card(
              color: Color.fromARGB(255, 179, 49, 240),
              child: Text(
                '1501',
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
