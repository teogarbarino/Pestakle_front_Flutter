import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pestakle/controllers/json_handler.dart';
import 'package:pestakle/controllers/provider/user_provider.dart';
import 'package:pestakle/controllers/service/https_service.dart';
import 'package:pestakle/models/post.dart';

import '../global/route.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late UserProvider pUser;
  late var img;
  List<Post> posts = [];
  bool dataready = false;

  @override
  void initState() {
    super.initState();
    pUser = Provider.of<UserProvider>(context, listen: false);
    getData();
  }

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          getData();
        },
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          (dataready)
              ? Expanded(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 100,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: posts
                            .map((post) => _buildPostItem(context, post))
                            .toList(),
                      ),
                    ),
                  ),
                )
              : const LinearProgressIndicator()
        ]),
      ),
    );
  }

  Image base64String(String data) {
    return Image.memory(base64Decode(data));
  }

  Widget _buildPostItem(BuildContext context, Post post) {
    return GestureDetector(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (post.image != "")
                  ? SizedBox(
                      height: 200,
                      child: Image.memory(
                        base64Decode(post.image),
                        fit: BoxFit.cover,
                      ))
                  : const SizedBox(),
              Text(
                post.description,
              ),
              const SizedBox(height: 8.0),
              Text(
                (post.createdAt).toString(),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      const Icon(Icons.message, size: 24),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            post.messages.length.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        onDoubleTap: () {
          _showBottomSheetForPost(post);
        });
  }

  void getData() async {
    try {
      var response = await HttpService().makeGetRequestWithToken(uGetPost);
      // Décode la réponse JSON
      List<dynamic> decodedResponse = jsonDecode(response.body);

      // Convertis chaque élément en Post
      posts = decodedResponse.map((json) => Post.fromJson(json)).toList();

      setState(() {
        dataready = true;
      });
    } catch (e) {
      print('Erreur lors de la récupération des posts: $e');
      setState(() {
        dataready = true;
      });
    }

    setState(() {
      dataready = true;
      posts;
    });
  }

  void _showBottomSheetForPost(Post post) {
    final TextEditingController messageController = TextEditingController();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Messages for post: ${post.title}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: post.messages.length,
                  itemBuilder: (context, index) {
                    final message = post.messages[index];
                    return Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        CircleAvatar(
                          backgroundImage:
                              MemoryImage(base64Decode(message.author.photo!)),
                          radius: 20,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.author.name,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              message.content!,
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, -2),
                        blurRadius: 6,
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ],
                  ),
                  child: Row(children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: const InputDecoration(
                          hintText: 'skrt skrt je suis le message a écrire ',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        if (messageController.text.isEmpty) return;

                        setState(() {
                          dataready = true;
                        });

                        try {
                          // Préparer les paramètres du message
                          final params = await JSONHandler().sendMessage(
                            postId: post.id,
                            content: messageController.text,
                          );

                          // Envoyer le message
                          final response =
                              await HttpService().makePostRequestWithToken(
                            uPostMessage(post.id),
                            params,
                          );

                          if (response.statusCode == 200) {
                            // Message envoyé avec succès
                            final newMessage = Message.fromJson(
                              jsonDecode(response.body),
                            );

                            // Mettre à jour la liste des messages
                            post.messages.add(newMessage);

                            messageController.clear();

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Message sent successfully!'),
                                ),
                              );
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Error sending message'),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error sending message'),
                              ),
                            );
                          }
                        } finally {
                          setState(() {
                            dataready = true;
                          });
                        }
                      },
                      child: const Text('Send'),
                    ),
                  ]))
            ],
          ),
        );
      },
    );
  }
}
