class Conversation {
  final String id;
  final List<String> users;
  final String? order;
  final DateTime createdAt;

  Conversation({
    required this.id,
    required this.users,
    this.order,
    required this.createdAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['_id'] ?? '',
      users:
          json['users'] != null ? List<String>.from(json['users']) : <String>[],
      order: json['order'], // Peut être null
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'users': users,
      'order': order,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
