import 'package:pestakle/models/post.dart';
import 'package:pestakle/models/user.dart';

class Conversation {
  final String id;
  final List<User> participants;
  final List<Message> messages;
  final DateTime createdAt;
  DateTime? updatedAt;

  Conversation({
    required this.id,
    required this.participants,
    required this.messages,
    required this.createdAt,
    this.updatedAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      participants: (json['participants'] as List)
          .map((userJson) => User.fromJson(userJson))
          .toList(),
      messages: (json['messages'] as List)
          .map((messageJson) => Message.fromJson(messageJson))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participants': participants.map((user) => user.toJson()).toList(),
      'messages': messages.map((message) => message.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Méthode pour ajouter un nouveau message à la conversation
  void addMessage(Message message) {
    messages.add(message);
    // Mettre à jour le champ updatedAt
    updatedAt = DateTime.now();
  }

  // Méthode pour vérifier si un utilisateur participe à la conversation
  bool containsParticipant(User user) {
    return participants.any((participant) => participant.id == user.id);
  }
}
