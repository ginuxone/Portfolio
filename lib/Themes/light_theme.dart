import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor:Colors.blue,
  fontFamily: 'Oswald',
  iconTheme: const IconThemeData(color: Colors.black),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.blue,
    splashColor: Colors.amber,
    textTheme: ButtonTextTheme.primary,
  ),
);