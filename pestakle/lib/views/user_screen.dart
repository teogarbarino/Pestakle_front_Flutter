import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:pestakle/controllers/json_handler.dart';
import 'package:pestakle/controllers/provider/user_provider.dart';
import 'package:pestakle/controllers/service/https_service.dart';
import 'package:pestakle/global/route.dart';
import 'package:pestakle/models/user.dart';
import 'package:pestakle/utils/dialog_boxes.dart';

class userpage extends StatefulWidget {
  const userpage({super.key});

  @override
  userpageState createState() => userpageState();
}

class userpageState extends State<userpage> {
  late UserProvider pUser;
  late User user;
  bool dataready = false;
  late var img;
  String newImgProfile = "";
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    pUser = Provider.of<UserProvider>(context, listen: false);
    getData();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        img = File(image.path);
      });

      newImgProfile = (await _encodeImageToBase64(img))!;
    }
  }

  Future<String?> _encodeImageToBase64(File? image) async {
    if (image == null) return null;
    final bytes = await image.readAsBytes();
    return base64Encode(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: (dataready)
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        (newImgProfile != "")
                            ? GestureDetector(
                                onTap: _pickImage,
                                child: CircleAvatar(
                                  backgroundImage:
                                      MemoryImage(base64Decode(newImgProfile)),
                                ),
                              )
                            : GestureDetector(
                                onTap: _pickImage,
                                child: CircleAvatar(
                                  backgroundImage: MemoryImage(base64Decode(
                                      pUser.getUser.profilePicture!)),
                                ),
                              ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 70),
                      child: TextFormField(
                        controller: nameController,
                        decoration:
                            const InputDecoration(labelText: 'Pseudonyme'),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: userModify,
                        child: const Text('Save Changes'),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const Center(
              child:
                  CircularProgressIndicator()), // Show loading indicator while fetching data
    );
  }

  void getData() async {
    user = pUser.getUser;

    nameController.text = user.username;
    img = user.profilePicture;

    setState(() {
      dataready = true;
    });
  }

  void userModify() async {
    var body =
        await JSONHandler().userModify(nameController.text, newImgProfile);

    var response = await HttpService().makePUTRequestWithToken(uPutUser, body);

    if (response.statusCode == 200) {
      if (!mounted) return;
      showPopUp("Succès", "Vos modifictions ont bien était pris en compte",
          "ok", "", context);
    } else {
      if (!mounted) return;
      showPopUp(
          "Erreur",
          "Une erreur s'est produite lors de la mise à jour de vos informations. Veuillez réessayer.",
          "ok",
          "",
          context);
    }
  }
}
