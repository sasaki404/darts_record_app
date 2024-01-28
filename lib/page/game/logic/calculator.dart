class Calculator {
  static int toScore(String str) {
    int? value = int.tryParse(str);
    if (value != null) {
      return value;
    } else {
      String upStr = str.toUpperCase();
      if (upStr == 'S-BULL' || upStr == 'D-BULL') {
        return 50;
      } else if (upStr == 'DOUBLE') {
        return -2; // adhocだけどしゃーないか
      } else if (upStr == 'TRIPLE') {
        return -3;
      } else if (upStr.startsWith('DOUBLE')) {
        return 2 * int.parse(upStr.split('-')[1]);
      } else if (upStr.startsWith('TRIPLE')) {
        return 3 * int.parse(upStr.split('-')[1]);
      } else {
        return 0;
      }
    }
  }

  static String getAward(List<String> strList, bool isCricket) {
    if (strList.length > 3) {
      return "";
    }
    int dBullCnt =
        strList.where((element) => element == "D-BULL").toList().length;
    int sBullCnt =
        strList.where((element) => element == "S-BULL").toList().length;
    if (strList.where((element) => element == "D-BULL").toList().length == 3) {
      return "THREE IN THE BLACK";
    }
    if (strList.where((element) => element == "TRIPLE-20").toList().length ==
        3) {
      return "TON80";
    }
    if (dBullCnt + sBullCnt == 3) {
      return "HAT TRICK";
    }
    int total = 0;
    for (var s in strList) {
      total += toScore(s);
    }
    if (150 <= total && total <= 179) {
      return "HIGH TON";
    }
    if (total >= 100) {
      return "LOW TON";
    }
    // TODO: THREE IN A BED, WHITE HORSE
    return "";
  }

  static bool isAward(String str) {
    bool res = false;
    for (var s in [
      'LOW TON',
      'HAT TRICK',
      'HIGH TON',
      'TON80',
      'THREE IN THE BLACK'
    ]) {
      if (str == s) {
        res = true;
      }
    }
    return res;
  }

  // 何回投げたか
  static int sumCountMap(Map<String, int> m) {
    int res = 0;
    for (var e in m.entries) {
      String key = e.key;
      int val = e.value;
      if (isAward(key)) {
        continue;
      }
      res += val;
    }
    return res;
  }
}
