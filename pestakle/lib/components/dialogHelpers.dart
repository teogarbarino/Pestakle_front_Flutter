import 'package:flutter/material.dart';

/// Affiche un dialogue de confirmation personnalisable avec deux boutons obligatoires.
///
/// [title] : le titre du dialogue.
/// [okButtonText] : le libellé du bouton de confirmation.
/// [cancelButtonText] : le libellé du bouton d'annulation.
/// [widget1] et [widget2] : widgets optionnels permettant de personnaliser le contenu.
///
/// Retourne un [Future<bool>] qui sera `true` si l'utilisateur confirme,
/// et `false` en cas d'annulation ou de fermeture du dialogue.
Future<bool> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String okButtonText,
  required String cancelButtonText,
  Widget? widget1,
  Widget? widget2,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      // Récupérer le style souhaité pour les TextButtons en fonction du thème actuel.
      final textButtonStyle = TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      );
      return AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget1 != null) widget1,
            if (widget1 != null && widget2 != null) const SizedBox(height: 8),
            if (widget2 != null) widget2,
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            style: textButtonStyle,
            child: Text(cancelButtonText),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            style: textButtonStyle,
            child: Text(okButtonText),
          ),
        ],
      );
    },
  );
  return result ?? false;
}

/// Affiche un dialogue d'information personnalisable.
///
/// [title] : le titre du dialogue.
/// [buttonText] : le libellé du bouton de fermeture.
/// [widget1] et [widget2] : widgets optionnels permettant de personnaliser le contenu.
///
/// Ce dialogue ne renvoie aucune valeur.
Future<void> showInfoDialog({
  required BuildContext context,
  required String title,
  required String buttonText,
  Widget? widget1,
  Widget? widget2,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      final textButtonStyle = TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      );
      return AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget1 != null) widget1,
            if (widget1 != null && widget2 != null) const SizedBox(height: 8),
            if (widget2 != null) widget2,
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: textButtonStyle,
            child: Text(buttonText),
          ),
        ],
      );
    },
  );
}

/// Affiche un dialogue proposant différentes méthodes de connexion.
/// Retourne une [Future<String?>] contenant la méthode choisie ("apple", "normish", "google")
/// ou null si l'utilisateur annule.
Future<String?> showLoginOptionsDialog({
  required BuildContext context,
  String title = "Choisissez votre méthode de connexion",
}) async {
  // Récupère la couleur "onSurface" qui est adaptée à chaque thème.
  final Color onSurfaceColor = Theme.of(context).colorScheme.onSurface;

  return await showDialog<String>(
    context: context,
    barrierDismissible:
        true, // L'utilisateur peut fermer le dialogue en cliquant à l'extérieur
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        title: Text(
          title,
          style: TextStyle(color: onSurfaceColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.apple, color: onSurfaceColor),
              title: Text(
                "Connexion Apple",
                style: TextStyle(color: onSurfaceColor),
              ),
              onTap: () {
                Navigator.of(context).pop("apple");
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: onSurfaceColor),
              title: Text(
                "Connexion Normish",
                style: TextStyle(color: onSurfaceColor),
              ),
              onTap: () {
                Navigator.of(context).pop("normish");
              },
            ),
            ListTile(
              leading: Icon(Icons.g_mobiledata, color: onSurfaceColor),
              title: Text(
                "Connexion Google",
                style: TextStyle(color: onSurfaceColor),
              ),
              onTap: () {
                Navigator.of(context).pop("google");
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(null);
            },
            style: TextButton.styleFrom(
              foregroundColor: onSurfaceColor,
            ),
            child: const Text("Annuler"),
          ),
        ],
      );
    },
  );
}

/// Affiche un dialogue proposant différentes méthodes d'inscription.
/// Retourne une [Future<String?>] contenant la méthode choisie ("apple", "google", "normish")
/// ou null si l'utilisateur annule.
Future<String?> showRegistrationOptionsDialog({
  required BuildContext context,
  String title = "Choisissez votre méthode d'inscription",
}) async {
  // On récupère la couleur onSurface du thème pour s'assurer que le texte s'affiche correctement.
  final Color onSurfaceColor = Theme.of(context).colorScheme.onSurface;

  return await showDialog<String>(
    context: context,
    barrierDismissible:
        true, // L'utilisateur peut fermer le dialogue en cliquant à l'extérieur.
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        title: Text(
          title,
          style: TextStyle(color: onSurfaceColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.apple, color: onSurfaceColor),
              title: Text("Inscription avec Apple",
                  style: TextStyle(color: onSurfaceColor)),
              onTap: () {
                Navigator.of(context).pop("apple");
              },
            ),
            ListTile(
              leading: Icon(Icons.g_mobiledata, color: onSurfaceColor),
              title: Text("Inscription avec Google",
                  style: TextStyle(color: onSurfaceColor)),
              onTap: () {
                Navigator.of(context).pop("google");
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: onSurfaceColor),
              title: Text("Inscription Normale",
                  style: TextStyle(color: onSurfaceColor)),
              onTap: () {
                Navigator.of(context).pop("normish");
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(null);
            },
            style: TextButton.styleFrom(
              foregroundColor: onSurfaceColor,
            ),
            child: const Text("Annuler"),
          ),
        ],
      );
    },
  );
}
