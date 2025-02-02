//  =======================================================
//      Fichier gérant l'user
//  =======================================================
// Flutter Imports
import 'package:flutter/material.dart';

import 'package:pestakle/models/user.dart';

class UserProvider extends ChangeNotifier {
  // Index par défaut
  User user = User(
    username: "",
    email: "",
    address: "",
    bio: "",
    profilePicture: "",
    role: "",
    trustIndex: 0.0,
    userSettings: UserSettings(
      theme: "",
      fontSize: 0.0,
    ),
  );

  User get getUser {
    return user;
  }

  void updateUser(User newUser) {
    user = newUser;
    notifyListeners();
  }

  void clearUser() {
    user = User(
      username: "",
      email: "",
      address: "",
      bio: "",
      profilePicture: "",
      role: "",
      trustIndex: 0.0,
      userSettings: UserSettings(
        theme: "",
        fontSize: 0.0,
      ),
    );
    notifyListeners();
  }
}
