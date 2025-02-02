class Message {
  final String id;
  final String sender;
  final String recipient;
  final String conversationId;
  final String content;
  final List<String> attachments;
  final double? offer;
  final String
      status; // Par exemple 'sent', 'accepted', 'rejected', 'countered'
  final DateTime createdAt;

  Message({
    required this.id,
    required this.sender,
    required this.recipient,
    required this.conversationId,
    required this.content,
    required this.attachments,
    this.offer,
    required this.status,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'] ?? '',
      sender: json['sender'] ?? '',
      recipient: json['recipient'] ?? '',
      conversationId: json['conversationId'] ?? '',
      content: json['content'] ?? '',
      attachments: json['attachments'] != null
          ? List<String>.from(json['attachments'])
          : <String>[],
      offer: json['offer'] != null ? (json['offer'] as num).toDouble() : null,
      status: json['status'] ?? 'sent',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sender': sender,
      'recipient': recipient,
      'conversationId': conversationId,
      'content': content,
      'attachments': attachments,
      'offer': offer,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
