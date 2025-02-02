import 'package:flutter/material.dart';
import 'package:pestakle/components/textfieldHelpers.dart'; // Assurez-vous que le chemin est correct

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  void _resetPassword() {
    final email = _emailController.text;
    final newPassword = _newPasswordController.text;
    // TODO: Implémentez ici la logique de réinitialisation du mot de passe (appel API, validation, etc.)
    print(
        "Réinitialisation du mot de passe pour $email avec nouveau mot de passe : $newPassword");
  }

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Réinitialisation de mot de passe"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo ou icône de réinitialisation (optionnel)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Icon(
                    Icons.lock_reset,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                // Champ Email
                CustomTextField(
                  controller: _emailController,
                  labelText: "Email",
                  hintText: "Entrez votre email",
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16.0),
                // Champ Nouveau mot de passe
                CustomTextField(
                  controller: _newPasswordController,
                  labelText: "Nouveau mot de passe",
                  hintText: "Entrez votre nouveau mot de passe",
                  obscureText: true,
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: _resetPassword,
                  child: const Text("Réinitialiser le mot de passe"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
