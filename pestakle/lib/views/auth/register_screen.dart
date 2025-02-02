import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pestakle/components/dialogHelpers.dart';
import 'package:pestakle/components/textfieldHelpers.dart';
import 'package:pestakle/controllers/provider/theme_provider.dart';
import 'package:pestakle/controllers/provider/user_provider.dart';
import 'package:pestakle/controllers/service/https_service.dart';
import 'package:pestakle/global/route.dart';
import 'package:pestakle/models/user.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers pour les champs obligatoires
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Controllers pour les champs optionnels
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  // Paramètre optionnel pour la taille de police
  double fontSize = 16;

  File? _image;

  // Providers
  late UserProvider pUser;
  late ThemeProvider pTheme;

  // Variable qui contiendra le type d'inscription (récupéré via arguments)
  late String registrationMethod;
  bool _didSetMethod = false;

  @override
  void initState() {
    super.initState();
    pUser = Provider.of<UserProvider>(context, listen: false);
    pTheme = Provider.of<ThemeProvider>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didSetMethod) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map && args.containsKey('registrationMethod')) {
        registrationMethod = args['registrationMethod'] as String;
      } else {
        // Par défaut, inscription classique
        registrationMethod = "normish";
      }
      _didSetMethod = true;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<String?> _encodeImageToBase64(File? image) async {
    if (image == null) return null;
    final bytes = await image.readAsBytes();
    return base64Encode(bytes);
  }

  void _submitForm() async {
    bool wantProfile = await showConfirmationDialog(
      context: context,
      title: "Définir un profil ?",
      okButtonText: "Oui",
      cancelButtonText: "Non",
      widget1: const Text("Souhaitez-vous définir des profils ?"),
    );
    if (wantProfile) {
      Navigator.pushNamed(context, '/profile');
    } else {
      Navigator.pushNamed(context, '/home');
    }

    if (_formKey.currentState?.validate() ?? false) {
      final username = _usernameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;
      final address = _addressController.text;
      final bio = _bioController.text;
      final imageBase64 = await _encodeImageToBase64(_image);

      User userToSend = User(
        username: username,
        email: email,
        address: address.isNotEmpty ? address : "",
        bio: bio.isNotEmpty ? bio : "",
        profilePicture: imageBase64 ?? "",
        role:
            registrationMethod, // Vous pouvez adapter ce champ selon la méthode d'inscription
        trustIndex: 0, // Calculé par l'application
        userSettings: UserSettings(
          theme: "light", // Valeur par défaut
          fontSize: fontSize,
        ),
      );

      final jsonString = jsonEncode(userToSend.toJson());

      var response = await HttpService()
          .makePostRequestWithoutToken(uPostRegister, jsonString);
      if (response.statusCode == 201) {
        Map<String, dynamic> decodedResponse = jsonDecode(response.body);
        User userToSave = User.fromJson(decodedResponse);
        pUser.updateUser(userToSave);
        Navigator.pushNamed(context, '/home');
      } else {
        // Afficher un pop-up d'erreur
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Attention"),
            content: const Text("Une erreur est survenue. Veuillez réessayer."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
      /*
      bool wantProfile = await showConfirmationDialog(
        context: context,
        title: "Définir un profil ?",
        okButtonText: "Oui",
        cancelButtonText: "Non",
        widget1: const Text("Souhaitez-vous définir des profils ?"),
      );
      if (wantProfile) {
        Navigator.pushNamed(context, '/createProfile');
      } else {
        Navigator.pushNamed(context, '/home');
      }
    } else {
      // Afficher un pop-up d'erreur
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Attention"),
          content: const Text("Une erreur est survenue. Veuillez réessayer."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );*/
    }
  }

  /// Construit le formulaire d'inscription
  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16.0),
        children: [
          // Sélection de l'image de profil via un CircleAvatar
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.surface,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null
                    ? Icon(Icons.add_a_photo,
                        size: 40, color: Theme.of(context).iconTheme.color)
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          // Champs obligatoires avec indication par une étoile (sans couleur en dur)
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username *',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un nom d\'utilisateur';
              }
              return null;
            },
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email *',
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty || !value.contains('@')) {
                return 'Veuillez entrer un email valide';
              }
              return null;
            },
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Mot de passe *',
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.length < 6) {
                return 'Le mot de passe doit contenir au moins 6 caractères';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          // Panneau dépliant pour les champs optionnels
          ExpansionTile(
            title: Row(
              children: [
                const Text("Paramètres utilisateur (optionnel)"),
                const SizedBox(width: 4.0),
                Icon(
                  Icons.star,
                  size: 16.0,
                ),
              ],
            ),
            children: [
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Adresse (optionnel)',
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(
                  labelText: 'Bio (optionnel)',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 8.0),
              // Slider pour la taille de police avec texte d'exemple dynamique
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Taille de police: ${fontSize.toStringAsFixed(0)}"),
                  Slider(
                    value: fontSize,
                    min: 12,
                    max: 24,
                    divisions: 12,
                    label: fontSize.toStringAsFixed(0),
                    onChanged: (value) => setState(() => fontSize = value),
                  ),
                  Center(
                    child: Text(
                      "Exemple de texte",
                      style: TextStyle(fontSize: fontSize),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
            ],
          ),
          const SizedBox(height: 16.0),
          // Switch pour le Dark Mode
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Mode Sombre"),
              const SizedBox(width: 8.0),
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme();
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _submitForm,
            child: const Text('S\'inscrire'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription'),
      ),
      body: SingleChildScrollView(
        child: _buildForm(),
      ),
    );
  }
}
