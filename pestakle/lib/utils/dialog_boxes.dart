//  ================================================================================================
//      Fichier contenant toutes les boîtes de dialogues de l'application (pop-up / alertbox...)
//  ================================================================================================

// Librairies externes à l'application
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';

//  ==================================================================
//      Pop-up classique avec titre / content / Un ou deux boutons
//  ==================================================================
Future<bool?> showPopUp(
    String title, String content, String okButton, String cancelButton, context,
    {bool twoButtons = false}) async {
  Future<bool?> result;
  if (kIsWeb) {
    result = showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(title),
                content: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ListBody(
                    children: <Widget>[Text(content)],
                  ),
                ),
                actions: <Widget>[
                  (twoButtons)
                      // Si deux boutons, on affiche le bouton annuler en premier
                      ? TextButton(
                          child: Text(cancelButton),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        )
                      // Sinon on met une SizedBox vide
                      : const SizedBox(),
                  // On affiche le bouton validation en dernier
                  TextButton(
                    child: Text(okButton),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            },
          );
        });
  } else if (Platform.isAndroid) {
    result = showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(title),
                content: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ListBody(
                    children: <Widget>[Text(content)],
                  ),
                ),
                actions: <Widget>[
                  (twoButtons)
                      // Si deux boutons, on affiche le bouton annuler en premier
                      ? TextButton(
                          child: Text(cancelButton),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        )
                      // Sinon on met une SizedBox vide
                      : const SizedBox(),
                  // On affiche le bouton validation en dernier
                  TextButton(
                    child: Text(okButton),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            },
          );
        });
  } else {
    result = showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return CupertinoAlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ListBody(
                  children: <Widget>[Text(content)],
                ),
              ),
              actions: <Widget>[
                (twoButtons)
                    // Si deux boutons, on affiche le bouton annuler en premier
                    ? CupertinoDialogAction(
                        child: Text(cancelButton),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      )
                    // Sinon on met une SizedBox vide
                    : const SizedBox(),
                // On affiche le bouton validation en dernier
                CupertinoDialogAction(
                  child: Text(okButton),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          });
        });
  }
  // On renvoie le result par lequel est passé le script
  return result;
}
