import 'package:flutter/material.dart';
import 'package:pestakle/components/textfieldHelpers.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Variable qui contiendra la méthode de connexion (récupérée via les arguments)
  late String loginMethod;

  // Flag pour s'assurer que l'initialisation ne se fait qu'une seule fois
  bool _didSetMethod = false;

  // Controllers pour la connexion "normale"
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didSetMethod) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map && args.containsKey('loginMethod')) {
        loginMethod = args['loginMethod'] as String;
      } else {
        // Valeur par défaut
        loginMethod = "normish";
      }
      _didSetMethod = true;
    }
  }

  /// Connexion classique via email/mot de passe (API Normish)
  void _loginNormal() {
    final email = _emailController.text;
    final password = _passwordController.text;
    // TODO: Implémenter l'appel à votre API de connexion "normish"
    print("Connexion Normish avec email: $email et mot de passe: $password");
  }

  /// Connexion via l'API Apple
  void _loginApple() {
    // TODO: Implémenter l'appel à votre API Apple
    print("Connexion via Apple");
  }

  /// Connexion via l'API Google
  void _loginGoogle() {
    // TODO: Implémenter l'appel à votre API Google
    print("Connexion via Google");
  }

  /// Action pour le lien "Mot de passe oublié ?"
  void _forgotPassword() {
    Navigator.pushNamed(context, '/forgotPassword');
  }

  /// Construit l'interface en fonction de la méthode de connexion sélectionnée
  Widget _buildLoginForm() {
    switch (loginMethod) {
      case "apple":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Connexion via Apple",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _loginApple,
              child: const Text("Se connecter avec Apple"),
            ),
          ],
        );
      case "google":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Connexion via Google",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _loginGoogle,
              child: const Text("Se connecter avec Google"),
            ),
          ],
        );
      case "normish":
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              controller: _emailController,
              labelText: "Email",
              hintText: "Entrez votre email",
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16.0),
            CustomTextField(
              controller: _passwordController,
              labelText: "Mot de passe",
              hintText: "Entrez votre mot de passe",
              obscureText: true,
            ),
            // Lien "Mot de passe oublié ?" aligné à droite
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _forgotPassword,
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                ),
                child: const Text("Mot de passe oublié ?"),
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _loginNormal,
              child: const Text("Se connecter"),
            ),
          ],
        );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // L'interface ne demande plus de pop-up, la méthode est transmise via les arguments
    return Scaffold(
      appBar: AppBar(title: const Text("Connexion")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo en haut
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Image.asset(
                    'assets/pestacle.jpg',
                    height: 120,
                  ),
                ),
                _buildLoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
