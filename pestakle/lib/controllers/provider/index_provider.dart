//  =======================================================
//      Fichier gérant l'index du BottomsBarNavigation
//  =======================================================
// Flutter Imports
import 'package:flutter/material.dart';

class IndexProvider extends ChangeNotifier {
  // Index par défaut
  int screenIndex = 0;

  int get getScreenIndex {
    return screenIndex;
  }

  void updateScreenIndex(int newIndex) {
    screenIndex = newIndex;
    notifyListeners();
  }
}
