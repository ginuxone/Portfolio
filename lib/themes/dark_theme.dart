import 'package:flutter/material.dart';
import 'package:portfolio/themes/colors.dart';

final ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: colorPrimaryDark,
    secondary: colorAccentDark,
    brightness: Brightness.dark,
  ),
  fontFamily: 'Oswald',
  iconTheme: const IconThemeData(color: Colors.white),
);
