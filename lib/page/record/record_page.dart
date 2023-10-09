import 'package:darts_record_app/database/count_up_record_db.dart';
import 'package:darts_record_app/model/count_up_record.dart';
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
      appBar: AppBar(
        // TODO: actionsプロパティとかで、カウントアップ以外のゲームの記録に切り替える
        title: Text(
          'RECORD',
          style: GoogleFonts.bebasNeue(fontSize: 50, color: AppColor.black),
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
                            fontSize: 50, color: AppColor.black),
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
                        return ListTile(
                          title: Text(
                            "${record.score} STATS: ${record.score / 8}",
                            style: GoogleFonts.bebasNeue(
                                fontSize: 50, color: AppColor.black),
                          ),
                          subtitle: Text(date),
                        );
                      },
                    );
            }
          }),
    );
  }
}
