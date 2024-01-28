import 'package:darts_record_app/database/daily_record_table.dart';
import 'package:darts_record_app/kv/login_user_id.dart';
import 'package:darts_record_app/model/daily_record.dart';
import 'package:darts_record_app/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});
  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends ConsumerState<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;
  List<String> _selectedEvents = [];
  Future<List<DailyRecord>>? dailyRecords;
  final dailyRecordTable = DailyRecordTable();

  @override
  void initState() {
    super.initState();
    loadLoginUserId().then((id) {
      setState(() {
        dailyRecords = dailyRecordTable.selectAll(id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return Scaffold(
      backgroundColor: AppColor.darkGrey,
      body: FutureBuilder(
          future: dailyRecords,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final records = snapshot.data;
            Map<DateTime, List<String>> events = {};
            if (records != null) {
              events = DailyRecord.createEvent(records);
            }
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                TableCalendar(
                  headerStyle: const HeaderStyle(
                    titleTextStyle: TextStyle(color: Colors.white),
                    formatButtonTextStyle: TextStyle(color: Colors.white),
                    formatButtonDecoration: BoxDecoration(
                        border: Border.fromBorderSide(
                            BorderSide(color: Colors.white)),
                        borderRadius:
                            BorderRadius.all(Radius.circular(12.0))),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                    ),
                  ),
                  calendarStyle: const CalendarStyle(
                    defaultTextStyle: TextStyle(color: Colors.white),
                  ),
                  firstDay: DateTime.utc(2023, 1, 1),
                  lastDay: DateTime(now.year, now.month + 2, 0),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      _selectedEvents = events[selectedDay] ?? [];
                    });
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  eventLoader: (date) {
                    return events[date] ?? [];
                  },
                  calendarBuilders: CalendarBuilders(
                    dowBuilder: (context, day) {
                      final text = DateFormat.E().format(day);
                      if (day.weekday == DateTime.sunday) {
                        return Center(
                          child: Text(
                            text,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      } else if (day.weekday == DateTime.saturday) {
                        return Center(
                          child: Text(
                            text,
                            style: const TextStyle(color: Colors.blue),
                          ),
                        );
                      } else {
                        return Center(
                          child: Text(
                            text,
                            style: const TextStyle(color: Colors.white60),
                          ),
                        );
                      }
                    },
                    defaultBuilder: (context, date, focusedDay) {
                      return Container(
                        margin: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            '${date.day}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _selectedEvents.length,
                    itemBuilder: (context, index) {
                      final event = _selectedEvents[index];
                      return Card(
                        child: ListTile(
                          title: Text(event),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }),
    );
  }
}
