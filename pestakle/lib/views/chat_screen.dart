import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pestakle/controllers/provider/user_provider.dart';
import 'package:pestakle/controllers/service/https_service.dart';
import 'package:pestakle/global/route.dart';
import 'package:pestakle/models/post.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';
import 'package:pestakle/models/conversation.dart';
import 'package:pestakle/models/user.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Conversation> conversations = [];
  Conversation? selectedConversation;
  late IO.Socket socket;
  List<User> allUsers = [];
  final ScrollController _scrollController = ScrollController();
  late UserProvider pUser;

  @override
  void initState() {
    super.initState();
    _initSocket();
    _loadConversations();
    _loadUsers();

    pUser = Provider.of<UserProvider>(context, listen: false);
  }

  void _initSocket() {
    socket = IO.io(baseUrlClassic, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();
    socket.on('message', (data) {
      // Mettre à jour la conversation avec le nouveau message
      if (selectedConversation != null) {
        setState(() {
          selectedConversation!.addMessage(Message.fromJson(data));
        });
        _scrollToBottom();
      }
    });
  }

  Future<void> _loadConversations() async {
    final response = await HttpService().makeGetRequestWithToken(
      uGetConversation,
    );
    if (response.statusCode == 200) {
      setState(() {
        conversations = (jsonDecode(response.body) as List)
            .map((json) => Conversation.fromJson(json))
            .toList();
      });
    }
  }

  Future<void> _loadUsers() async {
    final response = await HttpService().makeGetRequestWithToken(
      uGetUsers,
    );
    if (response.statusCode == 200) {
      setState(() {
        allUsers = (jsonDecode(response.body) as List)
            .map((json) => User.fromJson(json))
            .toList();
      });
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _showCreateConversationDialog() {
    User? selectedUser;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nouvelle conversation'),
          content: DropdownButton<User>(
            value: selectedUser,
            hint: const Text('Sélectionner un utilisateur'),
            items: allUsers.map((User user) {
              return DropdownMenuItem<User>(
                value: user,
                child: Text(user.name),
              );
            }).toList(),
            onChanged: (User? value) {
              selectedUser = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Créer'),
              onPressed: () async {
                if (selectedUser != null) {
                  final response = await HttpService().makePostRequestWithToken(
                    uPostConversation,
                    jsonEncode({
                      'participants': [selectedUser!.id],
                    }),
                  );

                  if (response.statusCode == 201) {
                    _loadConversations();
                    Navigator.pop(context);
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showCreateConversationDialog,
          ),
        ],
      ),
      body: Row(
        children: [
          // Liste des conversations
          Container(
            width: 300,
            child: ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                return ListTile(
                  selected: selectedConversation?.id == conversation.id,
                  title: Text(conversation.participants
                      .map((user) => user.name)
                      .join(', ')),
                  subtitle: Text(
                    conversation.messages.isNotEmpty
                        ? conversation.messages.last.content!
                        : 'Pas de messages',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    setState(() {
                      selectedConversation = conversation;
                    });
                  },
                );
              },
            ),
          ),
          // Zone de messages
          Expanded(
            child: Column(
              children: [
                // Messages
                Expanded(
                  child: selectedConversation == null
                      ? const Center(child: Text('Sélectionnez une conversation'))
                      : SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: selectedConversation!.messages
                                .map((message) => Container(
                                      padding: const EdgeInsets.all(8),
                                      alignment:
                                          message.author.id == pUser.getUser.id
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: message.author.id ==
                                                  pUser.getUser.id
                                              ? Colors.blue
                                              : Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Text(
                                          message.content!,
                                          style: TextStyle(
                                            color: message.author.id ==
                                                    pUser.getUser.id
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                ),
                // Zone de saisie
                if (selectedConversation != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: const InputDecoration(
                              hintText: 'Écrivez votre message...',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            if (_messageController.text.isNotEmpty) {
                              socket.emit('message', {
                                'conversationId': selectedConversation!.id,
                                'content': _messageController.text,
                              });
                              _messageController.clear();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    socket.disconnect();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
