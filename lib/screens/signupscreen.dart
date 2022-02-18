import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems_login_signup/screens/homescreen.dart';
import 'package:ems_login_signup/screens/signinscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ems_login_signup/helpers/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ems_login_signup/models/model.dart';

import '../helpers/colors.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final List<String> _genderItems = <String>["Male", "Female"];
  String? _selectedGender;
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  String? imageUrl;
  String? errorMessage;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  hidePassword() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  hideConfirmPassword() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  String? get selectedGender => _selectedGender;

  set selectedGender(String? item) {
    setState(() {
      _selectedGender = item;
      print(selectedGender);
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
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.6,
                    child: TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        nameController.text = value!;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: "Name",
                      ),
                      validator: (value) {
                        if (value!=null && value.isNotEmpty && value.length > 3){
                          return null;
                        }
                        else{
                          return 'Enter minimum 3 characters';
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.6,
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) {
                        emailController.text = value!;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                        hintText: "Email Address",
                      ),
                      validator: (value) {
                        if (value!=null && value.isNotEmpty){
                          return null;
                        }
                        else{
                          return 'Enter valid email';
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.6,
                    child: DropdownButton(
                      value: selectedGender,
                      isExpanded: true,
                      icon: Icon(Icons.person),
                      underline: Container(),
                      hint: Text('Select Gender'),
                      items: _genderItems
                          .map<DropdownMenuItem<String>>(
                              (e) =>
                              DropdownMenuItem<String>(
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
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.6,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      obscureText: _obscureText1,
                      controller: passwordController,
                      onSaved: (value) {
                        passwordController.text = value!;
                      },
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                          icon: Icon(_obscureText1
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            hidePassword();
                          },
                        ),
                        hintText: "Password",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.6,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: confirmPasswordController,
                      onSaved: (value) {
                        confirmPasswordController.text = value!;
                      },
                      obscureText: _obscureText2,
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                          onPressed: () {
                            hideConfirmPassword();
                          },
                          icon: Icon(_obscureText2
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        hintText: "Confirm Password",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.6,
                    child: ElevatedButton(
                      onPressed: () {
                        signUpUser();
                      },
                      // onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));},
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Text(
                      'Already have an account?',
                      style: TextStyle(),
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

  void signUpUser() async {
    if (formKey.currentState!.validate()) {
      try {
       if(imageUrl == null){
         Fluttertoast.showToast(msg: 'Select Image File!!');
       }
       else{
         await firebaseAuth.createUserWithEmailAndPassword(
             email: emailController.text, password: passwordController.text)
             .then((value) => {toFirestore()})
             .catchError((e) {
           Fluttertoast.showToast(msg: e!.message);
         });
       }
      }
      on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Email is invalid";
            break;

          case "wrong-password":
            errorMessage = "Password is Wrong";
            break;

          case "user-not-found":
            errorMessage = "User does not exist";
            break;

          default:
            errorMessage = "Undefined error";
        }

        Fluttertoast.showToast(msg: errorMessage!);

      }
    }
  }

  toFirestore() async{
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = firebaseAuth.currentUser;

    UserModel userModel = UserModel();
    userModel.name = nameController.text;
    userModel.email = user!.email;
    userModel.gender = selectedGender;
    userModel.userUid = user!.uid;
    userModel.imageUrl = imageUrl;

    firebaseFirestore.collection("users").doc(user.uid).set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created!!");
    Navigator.pushAndRemoveUntil((context), MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
  }

  Container UserImage(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 100,
      height: 100,
      child: Center(
        child: Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: theme.primaryColor,
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
    UploadTask uploadTask = firebaseStorage.ref('profileImage/').child(
        DateTime.now().toString()).putFile(_imageFile);
    var pictureUrl = await(await uploadTask).ref.getDownloadURL();
    setState(() {
      imageUrl = pictureUrl.toString();
    });
    print(imageUrl);
    Fluttertoast.showToast(msg: 'Image uploaded');
  }
}
