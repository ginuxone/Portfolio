import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:portfolio/main.dart';

Future<void> pumpAppWithLocale(WidgetTester tester, Locale locale) async {
  tester.platformDispatcher.localesTestValue = [locale];
  addTearDown(tester.platformDispatcher.clearLocalesTestValue);
  await tester.pumpWidget(const MyApp());
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Homepage shows the English title', (tester) async {
    await pumpAppWithLocale(tester, const Locale('en'));
    expect(find.text('Welcome to my Portfolio!'), findsOneWidget);
  });

  testWidgets('Homepage shows the Spanish title', (tester) async {
    await pumpAppWithLocale(tester, const Locale('es'));
    expect(find.text('Bienvenido a mi Portafolio!'), findsOneWidget);
  });

  testWidgets('Homepage shows the Italian title', (tester) async {
    await pumpAppWithLocale(tester, const Locale('it'));
    expect(find.text('Benvenuto al mio Portfolio!'), findsOneWidget);
  });
}
