import 'package:flutter/material.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/pages/homepage.dart';
import 'package:portfolio/themes/dark_theme.dart';
import 'package:portfolio/themes/light_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gino Alessandro Milla - Portfolio',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      themeMode: ThemeMode.system,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const Homepage(),
    );
  }
}
