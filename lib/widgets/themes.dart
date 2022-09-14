// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTheme {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.deepPurple,
      fontFamily: GoogleFonts.lato().fontFamily,
      iconTheme: IconThemeData(color: Colors.black),
      textTheme: Theme.of(context).textTheme,
      appBarTheme: AppBarTheme(color: Colors.white, elevation: 0.0));

  static ThemeData darkTheme(BuildContext context) => ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.deepPurple,
      fontFamily: GoogleFonts.lato().fontFamily,
      iconTheme: IconThemeData(color: Colors.black),
      textTheme: Theme.of(context).textTheme,
      appBarTheme: AppBarTheme(color: Colors.white, elevation: 0.0));
}
