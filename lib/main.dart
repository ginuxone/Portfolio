import 'package:flutter/material.dart';
import 'package:portfolio/Themes/dark_theme.dart';
import 'package:portfolio/Themes/light_theme.dart';
import 'package:portfolio/Pages/homepage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gino Alessandro Milla - Portfolio',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      themeMode: ThemeMode.system,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: Homepage(),
    );
  }
}
