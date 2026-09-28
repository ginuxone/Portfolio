import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:portfolio/main.dart';

/// Pumps the site at a desktop size with the given locale. The hero and
/// sphere animate forever, so tests advance frames with [pump] instead of
/// `pumpAndSettle`.
Future<void> pumpSite(
  WidgetTester tester, {
  Locale locale = const Locale('en'),
  Size size = const Size(1400, 900),
}) async {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  tester.platformDispatcher.localesTestValue = [locale];
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearLocalesTestValue);
  await tester.pumpWidget(const MyApp());
  await tester.pump(const Duration(milliseconds: 100));
}

/// Scrolls [finder] into the middle of the screen, clear of the sticky nav.
Future<void> scrollTo(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    300,
    scrollable: find.byType(Scrollable).first,
  );
  await Scrollable.ensureVisible(tester.element(finder), alignment: 0.5);
  await tester.pump(const Duration(milliseconds: 300));
}

/// Lets an AnimatedSwitcher finish and drop its outgoing child.
Future<void> settleSwitch(WidgetTester tester) async {
  // Tickers start timing on their first frame, so step a few frames.
  for (var i = 0; i < 4; i++) {
    await tester.pump(const Duration(milliseconds: 150));
  }
}

void main() {
  testWidgets('renders hero, nav and every section', (tester) async {
    await pumpSite(tester);

    expect(find.text('Gino Alessandro Milla'), findsOneWidget);
    expect(find.text('Fullstack Software Engineer'), findsOneWidget);
    expect(find.text('View Projects'), findsOneWidget);
    // Nav links (some also appear as section titles).
    for (final link in ['Stack', 'Projects', 'Journey', 'Contact']) {
      expect(find.text(link), findsWidgets);
    }
    expect(find.text('Tech Stack'), findsOneWidget);
    expect(find.text('Flutter'), findsWidgets);
    expect(find.text('Selected Projects'), findsOneWidget);
    expect(find.text('Cascina Ronchi'), findsOneWidget);
    expect(find.text('cascinaronchi.it'), findsWidgets);
    expect(find.text('Journey'), findsWidgets);
    expect(find.text('Get in Touch'), findsWidgets);
  });

  testWidgets('localizes the UI in Spanish and Italian', (tester) async {
    await pumpSite(tester, locale: const Locale('es'));
    expect(find.text('Proyectos destacados'), findsOneWidget);

    await pumpSite(tester, locale: const Locale('it'));
    expect(find.text('Progetti selezionati'), findsOneWidget);
  });

  testWidgets('timeline scrub swaps the detail card', (tester) async {
    await pumpSite(tester);
    final slider = find.byType(Slider);
    await scrollTo(tester, slider);

    // Starts on the most recent role.
    expect(find.text('AntaresVision'), findsOneWidget);

    // Drag the thumb all the way to the oldest entry.
    await tester.drag(slider, const Offset(-2000, 0));
    await settleSwitch(tester);
    expect(find.text('AntaresVision'), findsNothing);
    expect(find.text('WinForms'), findsOneWidget);

    // Tapping a year label jumps to that entry.
    await tester.tap(find.text('2023'));
    await settleSwitch(tester);
    expect(find.text('Digital Twin platform'), findsOneWidget);
  });

  testWidgets('contact form validates and confirms', (tester) async {
    await pumpSite(tester);
    final send = find.text('Send Message');
    await scrollTo(tester, send);

    await tester.tap(send);
    await tester.pump();
    expect(find.text('This field is required'), findsNWidgets(3));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Ada');
    await tester.enterText(fields.at(1), 'not-an-email');
    await tester.enterText(fields.at(2), 'Hello!');
    await tester.tap(send);
    await tester.pump();
    expect(find.text('Enter a valid email address'), findsOneWidget);

    await tester.enterText(fields.at(1), 'ada@example.com');
    await tester.tap(send);
    await settleSwitch(tester);
    expect(find.text('Thanks, Ada — message received.'), findsOneWidget);
    expect(find.byType(TextFormField), findsNothing);
  });

  testWidgets('lays out on a phone without overflow', (tester) async {
    await pumpSite(tester, size: const Size(390, 844));
    expect(find.byTooltip('Menu'), findsOneWidget);
    await scrollTo(tester, find.text('Send Message'));
    expect(tester.takeException(), isNull);
  });
}
