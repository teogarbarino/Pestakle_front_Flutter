import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pestakle/views/product/create_product_screen.dart';
import 'package:pestakle/views/user_screen.dart';

AppBar appBarAccount(widthScreen, context, String providerImage) {
  return AppBar(
    centerTitle: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    // Le leading est un menu burger qui ouvre le Drawer
    leading: Builder(
      builder: (context) => IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
    ),
    // Le titre peut être personnalisé selon vos besoins
    title: const Padding(
      padding: EdgeInsets.only(top: 5),
      child: Text(''), // Vous pouvez ajouter un titre ici si besoin.
    ),
    actions: [
      // Bouton affichant l'image du profil (CircleAvatar)
      IconButton(
        icon: CircleAvatar(
          radius: 25,
          backgroundImage: MemoryImage(base64Decode(providerImage)),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => userpage()),
          );
        },
      ),
      // Bouton pour créer un produit
      IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateProduitsScreen(),
            ),
          );
        },
      ),
    ],
    bottom: PreferredSize(
      preferredSize: Size(widthScreen, 15),
      child: Container(
        height: 2,
        width: widthScreen,
        color: Colors.orange,
      ),
    ),
  );
}

AppBar appBarSignUp(widthScreen, context) {
  return AppBar(
    centerTitle: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: const Padding(
      padding: EdgeInsets.only(top: 5),
      child: Image(
        height: 50,
        width: 100,
        image: AssetImage('assets/Logos/logo.png'),
      ),
    ),
    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
      onPressed: () async {
        Navigator.pop(context);
      },
    ),
    bottom: PreferredSize(
      preferredSize: Size(widthScreen, 15),
      child: Row(
        children: [
          Container(
            height: 2,
            width: widthScreen,
            color: Colors.orange,
          ),
        ],
      ),
    ),
  );
}
