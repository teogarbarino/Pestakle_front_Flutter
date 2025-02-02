import 'package:flutter/material.dart';
import 'package:pestakle/models/conversation.dart';
import 'package:pestakle/models/message.dart';
import 'package:pestakle/models/order.dart';
import 'package:pestakle/views/offers/counter_offer.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key? key}) : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  late Conversation conversation;
  late List<Message> messages;
  late Order order;
  bool _initialized = false;

  final TextEditingController _messageController = TextEditingController();
  // Pour cet exemple, on considère "user1" comme l'utilisateur courant.
  final String currentUserId = "user1";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      // Initialisation de fausses données :
      conversation = Conversation(
        id: "conv1",
        users: ["user1", "user2"],
        order: "order1",
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      );

      messages = [
        Message(
          id: "msg1",
          sender: "user1",
          recipient: "user2",
          conversationId: "conv1",
          content: "Bonjour, est-ce toujours disponible ?",
          attachments: [],
          offer: null,
          status: "sent",
          createdAt: DateTime.now().subtract(const Duration(hours: 20)),
        ),
        Message(
          id: "msg2",
          sender: "user2",
          recipient: "user1",
          conversationId: "conv1",
          content: "Oui, il est encore disponible.",
          attachments: [],
          offer: null,
          status: "sent",
          createdAt: DateTime.now().subtract(const Duration(hours: 18)),
        ),
        Message(
          id: "msg3",
          sender: "user1",
          recipient: "user2",
          conversationId: "conv1",
          content: "Super, je l'achète pour 100€.",
          attachments: [],
          offer: 100.0,
          status: "sent",
          createdAt: DateTime.now().subtract(const Duration(hours: 16)),
        ),
        Message(
          id: "msg4",
          sender: "user2",
          recipient: "user1",
          conversationId: "conv1",
          content: "Parfait, je prépare la commande.",
          attachments: [],
          offer: null,
          status: "sent",
          createdAt: DateTime.now().subtract(const Duration(hours: 15)),
        ),
      ];

      order = Order(
        id: "order1",
        user: "user1",
        item: "item1",
        price: 100.0,
        isSent: true,
        isConfirm: false,
        conversation: "conv1",
        createdAt: DateTime.now().subtract(const Duration(hours: 14)),
      );

      _initialized = true;
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: currentUserId,
      recipient: conversation.users.firstWhere(
        (id) => id != currentUserId,
        orElse: () => "",
      ),
      conversationId: conversation.id,
      content: text,
      attachments: [],
      offer: null,
      status: "sent",
      createdAt: DateTime.now(),
    );
    setState(() {
      messages.add(newMessage);
      _messageController.clear();
    });
    // Ajoutez ici la logique d'envoi vers le backend si nécessaire
  }

  /// Renvoie le dernier message ayant une offre (si existant), sinon null.
  Message? getLastOfferMessage() {
    // Filtrer les messages qui ont une offre non nulle
    final offerMessages = messages.where((msg) => msg.offer != null).toList();
    if (offerMessages.isNotEmpty) {
      // On renvoie le dernier message ayant une offre (le plus récent)
      offerMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return offerMessages.last;
    }
    return null;
  }

  /// Affiche une bannière de contre-offre si une offre existe
  Widget _buildOfferBanner() {
    final offerMsg = getLastOfferMessage();
    if (offerMsg == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => _showOfferDetails(offerMsg, context),
      child: Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            const Icon(Icons.local_offer, color: Colors.black),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Nouvelle offre: ${offerMsg.offer?.toStringAsFixed(2)} €",
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const Icon(Icons.arrow_forward, color: Colors.black),
          ],
        ),
      ),
    );
  }

  /// Affiche un dialogue avec les détails de l'offre et des boutons d'action
  void _showOfferDetails(Message offerMsg, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Détails de l'offre"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Offre proposée: ${offerMsg.offer?.toStringAsFixed(2)} €"),
              const SizedBox(height: 16),
              // Autres détails si nécessaire
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigue vers l'écran de contre‑offre et récupère le résultat
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CounterOfferScreen(),
                  ),
                ).then((result) {
                  if (result != null && result is Map) {
                    // Création d'un message vide avec le champ offer mis à jour avec la contre‑offre
                    final newCounterOfferMessage = Message(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      sender: currentUserId,
                      recipient: conversation.users.firstWhere(
                        (id) => id != currentUserId,
                        orElse: () => "",
                      ),
                      conversationId: conversation.id,
                      content: "", // Message vide
                      attachments: [],
                      offer: result['counterOffer'] as double?,
                      status: "sent",
                      createdAt: DateTime.now(),
                    );
                    setState(() {
                      messages.add(newCounterOfferMessage);
                    });
                  }
                });
              },
              child: const Text("Contre‑offre"),
            ),
            TextButton(
              onPressed: () {
                // Logique pour accepter l'offre (à adapter)
                Navigator.pop(context);
              },
              child: const Text("Accepter"),
            ),
            TextButton(
              onPressed: () {
                // Logique pour refuser l'offre (à adapter)
                Navigator.pop(context);
              },
              child: const Text("Refuser"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMessageBubble(Message msg) {
    final isSentByMe = msg.sender == currentUserId;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Align(
        alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: isSentByMe ? Colors.blue : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment:
                isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                msg.content,
                style: TextStyle(
                  color: isSentByMe ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${msg.createdAt.hour.toString().padLeft(2, '0')}:${msg.createdAt.minute.toString().padLeft(2, '0')}",
                style: TextStyle(
                  color: isSentByMe ? Colors.white70 : Colors.black54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offerBanner = _buildOfferBanner();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conversation"),
      ),
      body: Column(
        children: [
          // Si une offre existe, on l'affiche en haut
          if (offerBanner is! SizedBox) offerBanner,
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, index) {
                return _buildMessageBubble(messages[index]);
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Type your message...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
