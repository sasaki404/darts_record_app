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
      for (var e in record.countMap.entries) {
        val += "${e.key} : ${e.value}count\n";
      }
      final date = record.targetDate.split("-");
      event[DateTime.utc(
          int.parse(date[0]), int.parse(date[1]), int.parse(date[2]))] = [val];
    }
    return event;
  }
}
