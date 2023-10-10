import 'package:darts_record_app/database/count_up_record_db.dart';
import 'package:darts_record_app/model/count_up_record.dart';
import 'package:darts_record_app/page/record/graph_page.dart';
import 'package:darts_record_app/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class RecordPage extends ConsumerStatefulWidget {
  RecordPage({super.key});

  @override
  RecordPageState createState() => RecordPageState();
}

class RecordPageState extends ConsumerState<RecordPage> {
  Future<List<CountUpRecord>>? countUpRecords;
  final countUpRecordDB = CountUpRecordDB();

  @override
  void initState() {
    super.initState();
    setState(() {
      countUpRecords = countUpRecordDB.selectByUserId(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightGrey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GraphPage(),
            ),
          );
        },
        backgroundColor: AppColor.black,
        child: const Icon(
          Icons.change_circle,
          color: AppColor.white,
        ),
      ),
      body: FutureBuilder(
          future: countUpRecords,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final records = snapshot.data!;
              return (records.isEmpty)
                  ? Center(
                      child: Text(
                        'NO RECORD',
                        style: GoogleFonts.bebasNeue(
                            fontSize: 50, color: AppColor.white),
                      ),
                    )
                  : ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemCount: records.length,
                      itemBuilder: (context, index) {
                        final record = records[index];
                        final date = DateFormat('yyyy/MM/dd')
                            .add_Hm()
                            .format(DateTime.parse(record.createdAt));
                        return Card(
                          color: AppColor.darkGrey,
                          shape: const RoundedRectangleBorder(
                            // 枠線を変更できる
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60), // Card左上の角に丸み
                              bottomRight:
                                  Radius.elliptical(40, 20), //Card左上の角の微調整
                              // (x, y) -> (元の角から左にどれだけ離れているか, 元の角から上にどれだけ離れているか)
                            ),
                          ),
                          child: Column(children: [
                            Text(
                              "${record.score}",
                              style: GoogleFonts.bebasNeue(
                                  fontSize: 40, color: AppColor.white),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "STATS: ${record.score / 8}",
                                  style: GoogleFonts.bebasNeue(
                                      fontSize: 20, color: AppColor.white),
                                ),
                                SizedBox(width: 30),
                                Text(
                                  date,
                                  style: GoogleFonts.bebasNeue(
                                      fontSize: 20, color: AppColor.white),
                                ),
                              ],
                            ),
                          ]),
                        );
                      },
                    );
            }
          }),
    );
  }
}
