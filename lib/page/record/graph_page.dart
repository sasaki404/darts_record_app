import 'package:darts_record_app/database/count_up_record_table.dart';
import 'package:darts_record_app/model/count_up_record.dart';
import 'package:darts_record_app/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class GraphPage extends ConsumerStatefulWidget {
  GraphPage({super.key});

  @override
  GraphPageState createState() => GraphPageState();
}

class GraphPageState extends ConsumerState<GraphPage> {
  Future<List<CountUpRecord>>? countUpRecords;
  final countUpRecordDB = CountUpRecordTable();

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
          centerTitle: true,
          backgroundColor: AppColor.darkGrey,
          title: Text(
            'COUNT-UP RECORD',
            style: GoogleFonts.bebasNeue(fontSize: 50, color: AppColor.white),
            textAlign: TextAlign.center,
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
                  : Center(
                      child: AspectRatio(
                        aspectRatio: 0.67,
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(18),
                            ),
                            color: AppColor.lightGrey,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 18,
                              left: 12,
                              top: 24,
                              bottom: 12,
                            ),
                            child: LineChart(LineChartData(
                              lineBarsData: [
                                LineChartBarData(
                                  color: AppColor.black,
                                  isCurved: false,
                                  spots: records
                                      .asMap()
                                      .entries
                                      .map((e) => FlSpot(e.key.toDouble(),
                                          e.value.score.toDouble()))
                                      .toList(),
                                )
                              ],
                              minY: 0,
                              titlesData: const FlTitlesData(
                                bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 1,
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                              ),
                              gridData: const FlGridData(
                                show: false,
                                horizontalInterval: 1.0,
                                verticalInterval: 1.0,
                              ),
                            )),
                          ),
                        ),
                      ),
                    );
            }
          },
        ));
  }
}
