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
      } else {
        return 0;
      }
    }
  }
}
