//  ======================================================================================================================
//      Page principale Ce fichier sert à la gestion du BottomNavigationBar en utilisant Provider
// ======================================================================================================================
// Flutter Imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pestakle/components/drawer.dart';
import 'package:provider/provider.dart';
import 'package:pestakle/controllers/provider/index_provider.dart';
import 'package:pestakle/controllers/provider/user_provider.dart';
import 'package:pestakle/utils/appbar.dart';
import 'package:pestakle/utils/dialog_boxes.dart';
import 'package:pestakle/views/chat_screen.dart';
import 'package:pestakle/views/feed_screen.dart'; // Pour exit l'application

class MainPage extends StatelessWidget {
  final List<Widget> screens = [const FeedScreen(), ChatScreen()];

  MainPage({super.key});

  //  ======================================================================================================================
  //                                                    VIEW SECTION
  //  ======================================================================================================================
  @override
  Widget build(BuildContext context) {
    // Récupérer l'index du screen provider
    final IndexProvider screenindexprovider =
        Provider.of<IndexProvider>(context);

    final pUser = Provider.of<UserProvider>(context);
    int currentScreenIndex = screenindexprovider.getScreenIndex;
    double widthScreen = MediaQuery.of(context).size.width;

    return WillPopScope(
        onWillPop: () async {
          // On demande à l'user s'il souhaite ou non quitter l'app
          var shouldPop = await showPopUp(
            "",
            "",
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
          // Définition appbar
          appBar: (currentScreenIndex == 0)
              ? appBarAccount(widthScreen, context, pUser.getUser.photo!)
              : null,
          // Def du BottomNavigationBar
           drawer: CustomDrawer (),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.black,
            showUnselectedLabels: true,
            currentIndex: currentScreenIndex,
            onTap: (value) => screenindexprovider.updateScreenIndex(value),
        
            // Liste des items du BottomNavigationBar
            items: [
              BottomNavigationBarItem(
                label: "Feed des posts",
                icon: Icon((currentScreenIndex == 0)
                    ? Icons.newspaper
                    : Icons.newspaper_outlined),
              ),
              BottomNavigationBarItem(
                label: "Message",
                icon: Icon((currentScreenIndex == 1)
                    ? Icons.message
                    : Icons.message_outlined),
              ),
            ],
          ),
          body: screens[currentScreenIndex],
        ));
  }
}
