import 'package:flutter/material.dart';
import 'package:ems_login_signup/helpers/colors.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData themeData(BuildContext context){
  return ThemeData(
      appBarTheme: AppBarTheme(color: kPrimaryColor),
      primaryColor: kPrimaryColor,
      accentColor: kSecondaryColor,
      brightness: Brightness.light,
      buttonTheme: ButtonThemeData(buttonColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          headline1: GoogleFonts.poppins(
            color: kPrimaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
          bodyText1: GoogleFonts.openSans(
            color: Colors.red,
            fontSize: 20,
          )
      )
  );
}