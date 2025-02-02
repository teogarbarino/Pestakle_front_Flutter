import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pestakle/components/drawer.dart';
import 'package:provider/provider.dart';
import 'package:pestakle/controllers/provider/index_provider.dart';
import 'package:pestakle/controllers/provider/user_provider.dart';
import 'package:pestakle/utils/appbar.dart';
import 'package:pestakle/utils/dialog_boxes.dart';
import 'package:pestakle/views/chat_screen.dart';
import 'package:pestakle/views/feed_screen.dart';

class MainPage extends StatelessWidget {
  final List<Widget> screens = [
    const FeedScreen(),
    // Vous pouvez ajouter d'autres écrans si nécessaire, par exemple le ChatScreen
    // const ChatScreen(),
  ];

  MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Récupérer l'index du screen via Provider
    final IndexProvider screenIndexProvider =
        Provider.of<IndexProvider>(context);
    final pUser = Provider.of<UserProvider>(context);
    int currentScreenIndex = screenIndexProvider.getScreenIndex;
    double widthScreen = MediaQuery.of(context).size.width;

    // Récupérer le thème courant
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        // Demande à l'utilisateur s'il souhaite quitter l'application
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
          return true;
        } else {
          return false;
        }
      },
      child: Scaffold(
        // Utilisation de l'appBar personnalisée, ici en passant les couleurs du thème via la fonction appBarAccount si nécessaire
        appBar: (currentScreenIndex == 0)
            ? appBarAccount(widthScreen, context, pUser.getUser.profilePicture)
            : null,
        drawer: CustomDrawer(),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: theme
              .colorScheme.onPrimary, // Par exemple, texte sur fond primaire
          unselectedItemColor:
              Colors.white, // Ou vous pouvez définir une couleur du thème
          type: BottomNavigationBarType.fixed,
          backgroundColor:
              theme.primaryColor, // Utilisation de la couleur primaire du thème
          showUnselectedLabels: true,
          currentIndex: currentScreenIndex,
          onTap: (value) => screenIndexProvider.updateScreenIndex(value),
          items: [
            BottomNavigationBarItem(
              label: "Home",
              icon: Icon(
                currentScreenIndex == 0
                    ? Icons.newspaper
                    : Icons.newspaper_outlined,
              ),
            ),
            BottomNavigationBarItem(
              label: "Message",
              icon: Icon(
                currentScreenIndex == 1
                    ? Icons.message
                    : Icons.message_outlined,
              ),
            ),
          ],
        ),
        body: screens[currentScreenIndex],
      ),
    );
  }
}
