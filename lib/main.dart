import 'package:flutter/material.dart';
import 'package:portfolio/data/profile.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/screens/home_screen.dart';
import 'package:portfolio/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '${Profile.name} - Portfolio',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      themeMode: ThemeMode.dark,
      theme: appTheme,
      darkTheme: appTheme,
      home: const HomeScreen(),
    );
  }
}
