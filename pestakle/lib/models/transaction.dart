class Transaction {
  final String id;
  final String buyer;
  final String seller;
  final String item;
  final double price;
  final String transactionStatus; // 'pending', 'confirmed', 'cancelled'
  final String paymentMethod; // 'credit_card', 'paypal', 'bank_transfer'
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.buyer,
    required this.seller,
    required this.item,
    required this.price,
    required this.transactionStatus,
    required this.paymentMethod,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'] ?? '',
      buyer: json['buyer'] ?? '',
      seller: json['seller'] ?? '',
      item: json['item'] ?? '',
      price: (json['price'] as num).toDouble(),
      transactionStatus: json['transactionStatus'] ?? 'pending',
      paymentMethod: json['paymentMethod'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'buyer': buyer,
      'seller': seller,
      'item': item,
      'price': price,
      'transactionStatus': transactionStatus,
      'paymentMethod': paymentMethod,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
