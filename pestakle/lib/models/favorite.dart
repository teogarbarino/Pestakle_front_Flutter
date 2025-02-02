class Favorite {
  final String id;
  final String user;
  final String item;
  final DateTime createdAt;

  Favorite({
    required this.id,
    required this.user,
    required this.item,
    required this.createdAt,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['_id'] ?? '',
      user: json['user'] ?? '',
      item: json['item'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'item': item,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
