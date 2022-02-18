import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ems_login_signup/helpers/theme.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ems_login_signup/models/model.dart';

import 'homescreen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final List<String> _genderItems = <String>["Male", "Female"];
  String? _selectedGender;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference userReference =
      FirebaseFirestore.instance.collection('users');
  final formKey = GlobalKey<FormState>();
  String? imageUrl;
  String? errorMessage;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  String? get selectedGender => _selectedGender;

  UserModel userModel = UserModel();

  set selectedGender(String? item) {
    setState(() {
      _selectedGender = item;
      print(selectedGender);
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.userModel = UserModel.fromMap(value.data());

      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              alignment: Alignment.center,
              child: UserImage(context),
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        nameController.text = value!;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: '${userModel.name}',
                      ),
                      validator: (value) {
                        if (value != null &&
                            value.isNotEmpty &&
                            value.length > 3) {
                          return null;
                        } else {
                          return 'Enter minimum 3 characters';
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) {
                        emailController.text = value!;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                        hintText: '${userModel.email}',
                      ),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          return null;
                        } else {
                          return 'Enter valid email';
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: DropdownButton(
                      value: selectedGender,
                      isExpanded: true,
                      icon: Icon(Icons.person),
                      underline: Container(),
                      hint: Text('Select Gender'),
                      items: _genderItems
                          .map<DropdownMenuItem<String>>(
                              (e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(e),
                                  ))
                          .toList(),
                      onChanged: (dynamic value) => selectedGender = value,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ElevatedButton(
                      onPressed: () {
                        updateUser();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                      },
                      child: Text(
                        "Update",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container UserImage(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 100,
      height: 100,
      child: Center(
        child: Stack(
          children: [
            Container(
              height: 100,
              width: 100,
              child: userModel.imageUrl != null
                  ? CircleAvatar(
                      radius: 60,
                      child: CachedNetworkImage(
                        imageUrl: userModel.imageUrl!,
                        fit: BoxFit.fill,
                        imageBuilder: (context, imageProvider) => Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.fill),
                          ),
                        ),
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                          value: downloadProgress.progress,
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.error,
                          size: 70,
                          color: Colors.red,
                        ),
                      ),
                    )
                  : CircleAvatar(),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(120),
              onTap: () {
                showUserImageFilePicker(FileType.image);
              },
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: theme.accentColor.withOpacity(.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt_outlined,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showUserImageFilePicker(FileType fileType) async {
    final picker = ImagePicker();
    File _imageFile;
    final pickFile = await picker.pickImage(source: ImageSource.gallery);
    _imageFile = File(pickFile!.path);
    UploadTask uploadTask = firebaseStorage
        .ref('profileImage/')
        .child(DateTime.now().toString())
        .putFile(_imageFile);
    var pictureUrl = await (await uploadTask).ref.getDownloadURL();
    setState(() {
      imageUrl = pictureUrl.toString();
    });
    print(imageUrl);
    Fluttertoast.showToast(msg: 'Image uploaded');
  }

  Future<void> updateUser() {
    return userReference.doc(userModel.userUid).update({
      'name': nameController.text.isEmpty ? '${userModel.name}' : nameController.text,
      'email': emailController.text.isEmpty ? '${userModel.email}' : emailController.text,
      'gender': selectedGender == null ? '${userModel.gender}' : selectedGender,
      'imageUrl': imageUrl == null ? '${userModel.imageUrl}' : imageUrl,
    }).then((value) =>
        Fluttertoast.showToast(msg: 'Profile updated successfully!!'));
  }
}
