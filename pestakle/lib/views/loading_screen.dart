//  ===========================================================================================================================
//                                                Page d'accueil de l'app
//  ===========================================================================================================================

// Dart Imports
// Flutter Imports
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// External Imports
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:pestakle/controllers/json_handler.dart';
import 'package:pestakle/controllers/persistance_handler.dart';

import 'package:pestakle/controllers/provider/user_provider.dart';
import 'package:pestakle/controllers/service/https_service.dart';
import 'package:pestakle/global/route.dart';
import 'package:pestakle/models/user.dart';
import 'package:pestakle/utils/dialog_boxes.dart';
import 'package:pestakle/views/login_screen.dart';
import 'package:pestakle/views/menu.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  late UserProvider pUser;
  @override
  void initState() {
    super.initState();
    pUser = Provider.of<UserProvider>(context, listen: false);
    passToOtherScreen();
  }

//  ==============================================================================================================================================
//                                                              VIEW SECTION
//  ==============================================================================================================================================
  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        // On demande à l'user s'il souhaite ou non quitter l'app
        var shouldPop = await showPopUp(
          "Attention déconnexion",
          "Voulez vous quittez l'applications",
          "Oui",
          "Non",
          context,
          twoButtons: true,
        );
        if (shouldPop == true) {
          await SystemChannels.platform
              .invokeMethod<void>('SystemNavigator.pop', true);
          return true; // Pop Scope
        } else {
          return false; // Ne Pop Pas Le Scope
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            width: widthScreen,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // rajouter le  logo
                SizedBox(height: 20),
                SizedBox(
                  width: 240,
                  child: LinearProgressIndicator(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  passToOtherScreen() async {
    String refreshToken = await PersistanceHandler().getAccessToken();
    if (refreshToken != "notFound") {
      Response response =
          await HttpService().makePostRequestWithToken(uPostLogin, "");
      if (response.statusCode == 200) {
        if (context.mounted) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainPage()));
        }
      }
    } else {
      User resetedUser =
          User(email: '', name: '', password: '', photo: '', id: "");

      pUser.updateUser(resetedUser);

      PersistanceHandler().delAccessToken();

      // Renvoi au login
      if (context.mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const LoginPage(shouldGoMP: true)));
      }
    }
  }
}
