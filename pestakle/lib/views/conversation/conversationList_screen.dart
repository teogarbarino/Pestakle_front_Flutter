import 'package:flutter/material.dart';
import 'package:pestakle/models/conversation.dart';
import 'conversation_screen.dart';

class ConversationSelectionScreen extends StatefulWidget {
  const ConversationSelectionScreen({Key? key}) : super(key: key);

  @override
  _ConversationSelectionScreenState createState() =>
      _ConversationSelectionScreenState();
}

class _ConversationSelectionScreenState
    extends State<ConversationSelectionScreen> {
  List<Conversation>? conversationList;
  // Map pour stocker le dernier message de chaque conversation (clé: conversation.id)
  Map<String, String> lastMessages = {};

  // Fonction fictive pour récupérer des infos utilisateur (pseudonyme et image) à partir d'un userId.
  Map<String, String> _getUserInfo(String userId) {
    // Exemple de correspondance
    if (userId == "user2") {
      return {"name": "Alice", "image": "assets/alice.jpg"};
    } else if (userId == "user3") {
      return {"name": "Bob", "image": "assets/bob.jpg"};
    } else if (userId == "user4") {
      return {"name": "Charlie", "image": "assets/charlie.jpg"};
    }
    return {"name": userId, "image": "assets/default.jpg"};
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialisation des données factices une seule fois
    if (conversationList == null) {
      conversationList = [
        Conversation(
          id: "conv1",
          users: ["user1", "user2"],
          order: "order1",
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Conversation(
          id: "conv2",
          users: ["user1", "user3"],
          order: null,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Conversation(
          id: "conv3",
          users: ["user1", "user4"],
          order: "order3",
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];

      // Derniers messages factices pour chaque conversation
      lastMessages = {
        "conv1": "Bonjour, est-ce toujours disponible ?",
        "conv2": "Je suis intéressé par votre article.",
        "conv3": "Merci, la commande est en route.",
      };
    }
  }

  // Pour cet exemple, l'utilisateur courant est "user1".
  // La fonction retourne le pseudonyme du correspondant (le premier utilisateur différent de "user1").
  String _getConversationTitle(Conversation conv) {
    final otherUsers = conv.users.where((id) => id != "user1").toList();
    if (otherUsers.isNotEmpty) {
      final info = _getUserInfo(otherUsers.first);
      return info["name"]!;
    }
    return "Conversation";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: conversationList == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: conversationList!.length,
              itemBuilder: (context, index) {
                final conv = conversationList![index];
                final otherUsers =
                    conv.users.where((id) => id != "user1").toList();
                final userInfo = otherUsers.isNotEmpty
                    ? _getUserInfo(otherUsers.first)
                    : {"name": "Unknown", "image": "assets/default.jpg"};

                return ListTile(
                  leading: const CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage("assets/scarlet.jpeg"),
                  ),
                  title: Text(_getConversationTitle(conv)),
                  subtitle: Text(lastMessages[conv.id] ?? "No message yet"),
                  trailing: Text(
                    conv.createdAt.toLocal().toString().substring(0, 10),
                  ),
                  onTap: () {
                    // Navigue vers l'écran de conversation.
                    // Aucune donnée n'est passée ici, l'écran de conversation se chargera de récupérer les siennes via didChangeDependencies.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConversationScreen(),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
