class Order {
  final String id;
  final String user;
  final String item;
  final double price; // Nouveau champ pour le prix convenu ou contre-offre
  final bool isSent;
  final bool isConfirm;
  final String? conversation;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.user,
    required this.item,
    required this.price,
    required this.isSent,
    required this.isConfirm,
    this.conversation,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'] ?? '',
      user: json['user'] ?? '',
      item: json['item'] ?? '',
      // Conversion du prix en double
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : (json['price'] as num).toDouble(),
      isSent: json['isSent'] ?? false,
      isConfirm: json['isConfirm'] ?? false,
      conversation: json['conversation'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'item': item,
      'price': price,
      'isSent': isSent,
      'isConfirm': isConfirm,
      'conversation': conversation,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
