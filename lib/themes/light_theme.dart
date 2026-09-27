import 'package:flutter/material.dart';
import 'package:portfolio/themes/colors.dart';

final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: colorPrimaryLight,
    secondary: colorAccentLight,
    brightness: Brightness.light,
  ),
  fontFamily: 'Oswald',
  iconTheme: const IconThemeData(color: Colors.black),
);
