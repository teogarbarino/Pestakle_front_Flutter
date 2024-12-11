import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:pestakle/controllers/json_handler.dart';
import 'package:pestakle/controllers/persistance_handler.dart';
import 'package:pestakle/controllers/provider/user_provider.dart';
import 'package:pestakle/controllers/service/https_service.dart';
import 'package:pestakle/global/route.dart';
import 'package:pestakle/models/user.dart';
import 'package:pestakle/utils/dialog_boxes.dart';
import 'package:pestakle/views/menu.dart';

class RegistrationPage extends StatefulWidget {
  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  File? _image;
  late UserProvider pUser;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

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

  @override
  void initState() {
    super.initState();
    pUser = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 70),
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 70),
                child: TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 70),
                child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Pseudonyme'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: _image == null
                          ? const Icon(Icons.add, size: 40, color: Colors.grey)
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.file(
                                _image!,
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                child: const Text("S'enregistrer ma geule 667"),
                onPressed: () {
                  registerAndloginButtonAction(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void registerAndloginButtonAction(context) async {
    final String? base64Image = await _encodeImageToBase64(_image);
    User userToSend = User(
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
        photo: base64Image,
        id: '');

    final jsonString = jsonEncode(userToSend);

    var response = await HttpService()
        .makePostRequestWithoutToken(uPostRegister, jsonString);
    Map<String, dynamic> decodedResponse = jsonDecode(response.body);
    User userToSave = User.fromJson(decodedResponse);
    pUser.updateUser(userToSave);

    if (response.statusCode == 201) {
      var responseLogin = await HttpService()
          .makePostRequestWithoutToken(uPostLogin, jsonString);

      if (responseLogin.statusCode == 200) {
        Map<String, dynamic> decodedResponse = jsonDecode(responseLogin.body);

        await PersistanceHandler()
            .setAccessToken(decodedResponse['accessToken']);

        await PersistanceHandler()
            .setAccessToken(decodedResponse['accessToken']);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainPage()));
      } else {
        showPopUp("Attention", "Veuillez réessayer ultérieurement", "ok", "",
            context);
      }
    } else {
      showPopUp("Attention", "", "ok", "", context);
    }
  }
}
