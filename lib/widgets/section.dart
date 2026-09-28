import 'package:flutter/material.dart';
import 'package:portfolio/theme/tokens.dart';

/// Centers [child] at the max content width with responsive side gutters.
class ContentWidth extends StatelessWidget {
  const ContentWidth({super.key, required this.child});

  final Widget child;

  static double gutter(double width) =>
      width < Breakpoints.narrow ? AppSpace.lg : AppSpace.xxl;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSpace.maxContentWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: gutter(width)),
          child: child,
        ),
      ),
    );
  }
}

/// A page section: vertical rhythm, a header and its body.
class Section extends StatelessWidget {
  const Section({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.meta,
  });

  final String title;
  final String? subtitle;

  /// Right-aligned note next to the title (moves below it on narrow screens).
  final String? meta;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpace.section / 2),
      child: ContentWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(title: title, subtitle: subtitle, meta: meta),
            const SizedBox(height: AppSpace.xxl),
            child,
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.meta,
  });

  final String title;
  final String? subtitle;
  final String? meta;

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < Breakpoints.narrow;
    final heading = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 24, height: 1.5, color: AppColors.accent),
        const SizedBox(height: AppSpace.md),
        Semantics(header: true, child: Text(title, style: AppText.h2)),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpace.xs),
          Text(subtitle!, style: AppText.body),
        ],
      ],
    );
    if (meta == null) return heading;

    final metaText = Text(meta!, style: AppText.meta);
    if (narrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heading,
          const SizedBox(height: AppSpace.sm),
          metaText,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: heading),
        const SizedBox(width: AppSpace.lg),
        Padding(padding: const EdgeInsets.only(bottom: 6), child: metaText),
      ],
    );
  }
}
