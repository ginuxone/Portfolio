import 'package:flutter/material.dart';
import 'package:portfolio/components/animated_header.dart';
import 'package:portfolio/components/tab_wrapper.dart';
import 'package:portfolio/l10n/app_localizations.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AnimatedHeader(title: AppLocalizations.of(context)!.homepageTitle),
            const TabWrapper(),
          ],
        ),
      ),
    );
  }
}
