//  =======================================================
//      Fichier gérant l'user
//  =======================================================
// Flutter Imports
import 'package:flutter/material.dart';

import 'package:pestakle/models/user.dart';

class UserProvider extends ChangeNotifier {
  // Index par défaut
  User user = User(name: '', email: '', password: '', photo: "", id: '');

  User get getUser {
    return user;
  }

 

  void updateUser(User newUser) {
    user = newUser;
    notifyListeners();
  }
}
