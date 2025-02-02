class Wishlist {
  final String id;
  final String user;
  final String title;
  final List<String> items; // Liste d'IDs d'articles
  final DateTime createdAt;
  final DateTime updatedAt;

  Wishlist({
    required this.id,
    required this.user,
    required this.title,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Wishlist.fromJson(Map<String, dynamic> json) {
    return Wishlist(
      id: json['_id'] ?? '',
      user: json['user'] ?? '',
      title: json['title'] ?? '',
      items:
          json['items'] != null ? List<String>.from(json['items']) : <String>[],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'title': title,
      'items': items,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
