class CountUpRecord {
  final int id;
  final int userId;
  final int score;
  final List<int> scoreList;

  final String createdAt;
  final String? updatedAt;
  CountUpRecord({
    required this.id,
    required this.userId,
    required this.score,
    required this.scoreList,
    required this.createdAt,
    this.updatedAt,
  });

  factory CountUpRecord.fromSqfliteDatabase(Map<String, dynamic> map) =>
      CountUpRecord(
        id: map['id'].toInt() ?? 0,
        userId: map['user_id'] ?? '',
        score: map['score'] ?? 0,
        scoreList: strToScoreList(map['score_list']),
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'])
            .toIso8601String(),
        updatedAt: (map['updated_at'] == null)
            ? null
            : DateTime.fromMillisecondsSinceEpoch(map['updated_at'])
                .toIso8601String(),
      );

  // scoreListをDBに保存できる形に変換する
  static String scoreListToStr(List<int> list) {
    return list.map<String>((int e) => e.toString()).join(',');
  }

  // score_listカラムの値を内部で使える形に変換する
  static List<int> strToScoreList(String listStr) {
    return listStr
        .split(',')
        .map<int>((String scoreStr) => int.parse(scoreStr))
        .toList();
  }
}
