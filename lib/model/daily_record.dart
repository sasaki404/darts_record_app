import 'package:darts_record_app/page/game/logic/calculator.dart';

class DailyRecord {
  final int id;
  final int userId;
  final Map<String, int> countMap;
  final String targetDate;

  DailyRecord({
    required this.id,
    required this.userId,
    required this.countMap,
    required this.targetDate,
  });

  factory DailyRecord.fromSqfliteDatabase(Map<String, dynamic> map) =>
      DailyRecord(
        id: map['id'].toInt() ?? 0,
        userId: map['user_id'] ?? '',
        countMap: DailyRecord.strToCountMap(map['count_map']),
        targetDate: map['target_date'] ?? '',
      );

  // countMapをDBに保存できる形に変換する
  static String countMapToStr(Map<String, int> cMap) {
    // ex: {'s-bull':4,'d-bull':3,'low-ton':2,'1':5}
    String res = "{";
    cMap.forEach((key, val) {
      res += "$key:$val,";
    });
    res = "${res.substring(0, res.length - 1)}}";
    return res;
  }

  // count_mapカラムの値を内部で使える形に変換する
  static Map<String, int> strToCountMap(String str) {
    if (str.isEmpty) {
      return {};
    }
    // ex)"{S-BULL:3,D-BULL:2,20:4}"
    List<String> kv = str.substring(1, str.length - 1).split(',');
    Map<String, int> res = {};
    for (String pair in kv) {
      List<String> parts = pair.split(':');
      String key = parts[0].trim();
      int value = int.parse(parts[1].trim());
      res[key] = value;
    }

    return res;
  }

  static String toTargetDate(DateTime dt) {
    return "${dt.year}-${dt.month}-${dt.day}";
  }

  // countMapを更新する
  Map<String, int> updateCountMap(Map<String, int> prevMap) {
    for (var e in prevMap.entries) {
      if (countMap.containsKey(e.key)) {
        countMap[e.key] = countMap[e.key]! + e.value;
      } else {
        countMap[e.key] = e.value;
      }
    }
    return countMap;
  }

  // カレンダーイベントを作成する
  static Map<DateTime, List<String>> createEvent(List<DailyRecord> records) {
    Map<DateTime, List<String>> event = {};
    String val = "";
    for (var record in records) {
      List<String> sortedKeys = record.countMap.keys.toList()
        ..sort((a, b) => _customCompare(a, b));
      Map<String, int> sortedMap = {
        for (var key in sortedKeys) key: record.countMap[key]!
      };
      int sum = Calculator.sumCountMap(record.countMap);
      val += "total throw count : ${sum}\n";
      for (var e in sortedMap.entries) {
        val += "'${e.key}' : ${e.value}";
        if (!Calculator.isAward(e.key)) {
          val += "(${(100 * e.value / sum).toStringAsFixed(2)}%)";
        }
        val += ", ";
      }
      final date = record.targetDate.split("-");
      event[DateTime.utc(
          int.parse(date[0]), int.parse(date[1]), int.parse(date[2]))] = [val];
    }
    return event;
  }

  static int _customCompare(String a, String b) {
    List<String> order = [
      'DOUBLE-1',
      'DOUBLE-2',
      'DOUBLE-3',
      'DOUBLE-4',
      'DOUBLE-5',
      'DOUBLE-6',
      'DOUBLE-7',
      'DOUBLE-8',
      'DOUBLE-9',
      'DOUBLE-10',
      'DOUBLE-11',
      'DOUBLE-12',
      'DOUBLE-13',
      'DOUBLE-14',
      'DOUBLE-15',
      'DOUBLE-16',
      'DOUBLE-17',
      'DOUBLE-18',
      'DOUBLE-19',
      'DOUBLE-20',
      'TRIPLE-1',
      'TRIPLE-2',
      'TRIPLE-3',
      'TRIPLE-4',
      'TRIPLE-5',
      'TRIPLE-6',
      'TRIPLE-7',
      'TRIPLE-8',
      'TRIPLE-9',
      'TRIPLE-10',
      'TRIPLE-11',
      'TRIPLE-12',
      'TRIPLE-13',
      'TRIPLE-14',
      'TRIPLE-15',
      'TRIPLE-16',
      'TRIPLE-17',
      'TRIPLE-18',
      'TRIPLE-19',
      'TRIPLE-20',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      '11',
      '12',
      '13',
      '14',
      '15',
      '16',
      '17',
      '18',
      '19',
      '20',
      'S-BULL',
      'D-BULL',
      'LOW TON',
      'HAT TRICK',
      'HIGH TON',
      'TON80',
      'THREE IN THE BLACK'
    ];

    int indexA = order.indexOf(a);
    int indexB = order.indexOf(b);
    return indexB - indexA;
  }
}
