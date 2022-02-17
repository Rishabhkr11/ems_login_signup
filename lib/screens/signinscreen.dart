import 'package:ems_login_signup/screens/homescreen.dart';
import 'package:ems_login_signup/screens/signupscreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
             child: Column(
               children: [
                 Container(
                   width: MediaQuery.of(context).size.width * 0.6,
                   child: TextFormField(
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
                   width: MediaQuery.of(context).size.width * 0.6,
                   child: TextFormField(
                     keyboardType: TextInputType.text,
                     obscureText: true,
                     decoration: InputDecoration(
                       prefixIcon: Icon(Icons.lock),
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
                     onPressed: (){Get.to(() => HomeScreen());},
                     // onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));},
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
                   onTap: () {Navigator.push((context), MaterialPageRoute(builder: (context) => SignUp()));},
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
}
