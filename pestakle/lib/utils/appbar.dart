import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pestakle/views/post_screen.dart';
import 'package:pestakle/views/user_screen.dart';

AppBar appBarAccount(widthScreen, context, String providerImage) {
  return AppBar(
    centerTitle: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: Padding(
      padding: const EdgeInsets.only(top: 10),
      child: GestureDetector(
        child: CircleAvatar(
            radius: 25,
            backgroundImage: MemoryImage(base64Decode(providerImage))),
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => userpage())),
      ),
    ),
    title: const Padding(
      padding: EdgeInsets.only(top: 5),
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const PostScreen()));
        },
      ),
    ],
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
