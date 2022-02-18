import 'package:ems_login_signup/screens/homescreen.dart';
import 'package:ems_login_signup/screens/signupscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool _obscureText1 = true;
  String? errorMessage;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  hidePassword() {
    setState(() {
      _obscureText1 = !_obscureText1;
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
              child: Text(
                'FACIO',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
              ),
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                        hintText: "Email Address",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: _obscureText1,
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
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ElevatedButton(
                      onPressed: () {
                        loginUser();
                      },
                      child: Text(
                        "Login",
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
                      Navigator.push((context),
                          MaterialPageRoute(builder: (context) => SignUp()));
                    },
                    child: Text(
                      'Forgot Password?',
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

  void loginUser() async {
    if (formKey.currentState!.validate()) {
      try {
        await firebaseAuth.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
            .then((value) => {SendUsertoHomeScreen()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
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

  void SendUsertoHomeScreen(){
    Fluttertoast.showToast(msg: 'User logged In!!');
    Navigator.pushAndRemoveUntil((context), MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
  }
}
