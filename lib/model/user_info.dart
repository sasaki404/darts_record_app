class UserInfo {
  final int id;
  final String name;
  final double rating;

  final String createdAt;
  final String? updatedAt;
  UserInfo({
    required this.id,
    required this.name,
    required this.rating,
    required this.createdAt,
    this.updatedAt,
  });

  factory UserInfo.fromSqfliteDatabase(Map<String, dynamic> map) => UserInfo(
        id: map['id'].toInt() ?? 0,
        name: map['name'] ?? '',
        rating: map['rating'] ?? 0,
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'])
            .toIso8601String(),
        updatedAt: (map['updated_at'] == null)
            ? null
            : DateTime.fromMillisecondsSinceEpoch(map['updated_at'])
                .toIso8601String(),
      );

  // UserInfoのリストからidがキーのMapオブジェクトを作成
  static Map<int, UserInfo> createMapfromList(List<UserInfo> list) {
    Map<int, UserInfo> ret = {};
    for (var e in list) {
      ret[e.id] = e;
    }
    return ret;
  }
}
