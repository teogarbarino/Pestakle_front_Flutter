//  ===========================================================================================================================
//                                       Page principale de connexion
//  ===========================================================================================================================

// Flutter Imports
import 'package:flutter/material.dart';
import 'package:pestakle/views/test.dart';

import 'package:provider/provider.dart';
import 'package:pestakle/controllers/provider/index_provider.dart';
import 'package:pestakle/controllers/provider/user_provider.dart';
import 'package:pestakle/views/MainController.dart';

class LoginsPage extends StatefulWidget {
  final bool shouldGoMP;
  const LoginsPage({super.key, required this.shouldGoMP});

  @override
  State<LoginsPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginsPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;

  late UserProvider pUser;
  late IndexProvider pIndex;

  @override
  void initState() {
    super.initState();
    pUser = Provider.of<UserProvider>(context, listen: false);
    pIndex = Provider.of<IndexProvider>(context, listen: false);
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
          if (widget.shouldGoMP == true) {
            pIndex.updateScreenIndex(0);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MainPage()));
            return true;
          } else {
            Navigator.pop(context);
            return true;
          }
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: heightScreen / 6),
                  const Center(
                    child: Text(
                      "Connexion",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Center(
                    child: Image(
                      width: 240,
                      image: AssetImage('assets/667.webp'),
                    ),
                  ),
                  const SizedBox(height: 40),
                  /*
                  Row(
                    children: [
                      Container(
                        height: 2,
                        width: widthScreen,
                        color: Colors.orange,
                      ),
                    ],
                  ), */
                  const SizedBox(height: 30),
                  Container(
                    height: 70,
                    padding: const EdgeInsets.symmetric(horizontal: 70),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            left: 8.0, bottom: 8.0, top: 8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        labelText: 'E-Mail',
                        labelStyle: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 70,
                    padding: const EdgeInsets.symmetric(horizontal: 70),
                    child: TextField(
                      controller: passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            left: 8.0, bottom: 8.0, top: 8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        labelText: 'Mot de passe',
                        labelStyle: const TextStyle(color: Colors.black),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: widthScreen / 1.5,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {
                        loginButtonAction();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text("Connexion"),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: widthScreen / 1.5,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {
                        /*if (widget.shouldGoMP == true) {
                          pIndex.updateScreenIndex(0);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegistrationPage()));
                        } else {
                          Navigator.pop(context);
                        } */
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text("S'inscrire"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: widthScreen / 1.5,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RandomBentoGrid()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text("DEVELOPPEMENT SECRET "),
                    ),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: "Mot de passe oublié ?",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            )));
  }

  //  ==============================================================================================================================================
  //                                                             CONTROLLERS SECTION
  //  ==============================================================================================================================================
  // Fonction définissant l'action a effectuer en fonction du bouton sur lequel l'user à cliqué
  void loginButtonAction() async {
    emailController.text.trim();
    /*

    if (emailToSend == '') {
      await showPopUp(
        AppLocalizations.of(context)!.titleAlertPULogin,
        AppLocalizations.of(context)!.emptyMailPULogin,
        AppLocalizations.of(context)!.wordOk,
        AppLocalizations.of(context)!.wordOk,
        context,
      );
      return;
    } else if (!emailToSend.contains('@')) {
      await showPopUp(
        AppLocalizations.of(context)!.titleAlertPULogin,
        AppLocalizations.of(context)!.invalidMailPULogin,
        AppLocalizations.of(context)!.wordOk,
        AppLocalizations.of(context)!.wordOk,
        context,
      );
      return;
    }

    if (passwordController.text.trim() == '') {
      if (context.mounted) {
        await showPopUp(
          AppLocalizations.of(context)!.titleAlertPULogin,
          AppLocalizations.of(context)!.emptyPassPULogin,
          AppLocalizations.of(context)!.wordOk,
          AppLocalizations.of(context)!.wordOk,
          context,
        );
      }
      return;
    }

    String body = await JSONHandler()
        .postAccountLogin(emailToSend, passwordController.text);
    Response response =
        await HttpService().makePostRequestWithoutToken(uPostLogin, body);
    Map<String, dynamic> decodedResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // On set le refresh & l'access token et on les retire de la map decodedResponse pour créer notre user
      await PersistanceHandler().setRefreshToken(decodedResponse['refresh']);
      decodedResponse.removeWhere((key, value) => key == 'refresh');
      await PersistanceHandler().setAccessToken(decodedResponse['access']);
      decodedResponse.removeWhere((key, value) => key == 'access');

      User userToSave = User.fromJson(decodedResponse);

      // On sauvegarde l'user dans le persistance & dans un provider
      await PersistanceHandler().setUserInformation(userToSave);
      pUser.updateUser(userToSave);
      pIndex.updateScreenIndex(0);

      if (context.mounted) {
        await showPopUp(
          AppLocalizations.of(context)!.titlePUSuccesLog,
          AppLocalizations.of(context)!.contentPUSuccesLog,
          AppLocalizations.of(context)!.wordOk,
          AppLocalizations.of(context)!.wordOk,
          context,
        );
        if (context.mounted) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainPage()));
        }
      }
    } else if (response.statusCode == 401) {
      if (context.mounted) {
        await showPopUp(
          AppLocalizations.of(context)!.titlePUNoAccount,
          AppLocalizations.of(context)!.contentPUNoAccount,
          AppLocalizations.of(context)!.wordOk,
          AppLocalizations.of(context)!.wordOk,
          context,
        );
      }
    } else {
      if (context.mounted) {
        await showPopUp(
          AppLocalizations.of(context)!.titlePopUpError(response.statusCode),
          AppLocalizations.of(context)!.contentPopUpError,
          AppLocalizations.of(context)!.wordOk,
          AppLocalizations.of(context)!.wordOk,
          context,
        );
      }
    }*/
  }
}
