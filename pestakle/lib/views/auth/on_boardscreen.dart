import 'package:flutter/material.dart';
import 'package:pestakle/components/dialogHelpers.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Partie supérieure avec logo, titre et description
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo de l'application
                    Image.asset(
                      'assets/pestacle.jpg',
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 20.0),
                    // Message de bienvenue
                    const Text(
                      "Bienvenue dans notre application!",
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12.0),
                    // Description ou slogan
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        "Découvrez une expérience inédite pour gérer vos tâches et projets, "
                        "tout en profitant d'une interface élégante et moderne.",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              // Partie inférieure : container avec les boutons d'action
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Bouton "S'inscrire plus tard" avec confirmation
                    ElevatedButton(
                      onPressed: () async {
                        bool confirmed = await showConfirmationDialog(
                          context: context,
                          title: "Confirmation",
                          okButtonText: "Oui",
                          cancelButtonText: "Annuler",
                          widget1: const Text(
                              "Voulez-vous vraiment continuer sans vous inscrire ?"),
                        );
                        if (confirmed) {
                          Navigator.pushNamed(context, '/main');
                        }
                      },
                      child: const Text("S'inscrire plus tard"),
                    ),
                    const SizedBox(height: 12.0),
                    // Boutons "S'inscrire" et "Se connecter" côte à côte
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final chosenMethod =
                                  await showRegistrationOptionsDialog(
                                context: context,
                                title: "Choisissez votre méthode d'inscription",
                              );
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: const Text("S'inscrire"),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final chosenMethod = await showLoginOptionsDialog(
                                  context: context);
                              if (chosenMethod != null) {
                                Navigator.pushNamed(
                                  context,
                                  '/login',
                                  arguments: {'loginMethod': chosenMethod},
                                );
                              }
                            },
                            child: const Text("Se connecter"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
