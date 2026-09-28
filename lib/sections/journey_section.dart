import 'package:flutter/material.dart';
import 'package:portfolio/data/journey.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/widgets/section.dart';
import 'package:portfolio/widgets/timeline_scrub.dart';

class JourneySection extends StatelessWidget {
  const JourneySection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Section(
      title: l10n.journeyTitle,
      subtitle: l10n.journeySubtitle,
      child: TimelineScrub(entries: journey),
    );
  }
}
