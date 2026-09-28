import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/models/job_model.dart';
import 'package:portfolio/theme/tokens.dart';
import 'package:portfolio/widgets/pressable.dart';
import 'package:portfolio/widgets/tag_chip.dart';

/// Horizontal scrub timeline: a slider over the career entries (oldest on the
/// left), year labels under it, and a detail card for the selected entry.
class TimelineScrub extends StatefulWidget {
  const TimelineScrub({super.key, required this.entries});

  /// Entries, most recent first.
  final List<JobModel> entries;

  @override
  State<TimelineScrub> createState() => _TimelineScrubState();
}

class _TimelineScrubState extends State<TimelineScrub> {
  /// Thumb inset so labels line up with slider positions.
  static const _trackInset = 10.0;

  /// Chronological order, oldest first, to read left to right.
  late List<JobModel> _entries = widget.entries.reversed.toList();
  late int _index = _entries.length - 1;

  @override
  void didUpdateWidget(TimelineScrub oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entries != widget.entries) {
      _entries = widget.entries.reversed.toList();
      _index = _index.clamp(0, _entries.length - 1);
    }
  }

  void _select(int index) {
    if (index != _index) setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final last = _entries.length - 1;
    final entry = _entries[_index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          label: l10n.journeySlider,
          child: Slider(
            value: _index.toDouble(),
            max: last.toDouble(),
            divisions: last,
            padding: const EdgeInsets.symmetric(horizontal: _trackInset),
            label: '${entry.start.year}',
            semanticFormatterCallback: (v) =>
                '${_entries[v.round()].start.year}, ${_entries[v.round()].role}',
            onChanged: (v) => _select(v.round()),
          ),
        ),
        const SizedBox(height: AppSpace.xs),
        SizedBox(
          height: 24,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final track = constraints.maxWidth - _trackInset * 2;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  for (var i = 0; i <= last; i++)
                    Positioned(
                      left: _trackInset + track * (last == 0 ? 0 : i / last),
                      top: 0,
                      child: FractionalTranslation(
                        translation: const Offset(-0.5, 0),
                        child: _YearLabel(
                          year: _entries[i].start.year,
                          selected: i == _index,
                          onPressed: () => _select(i),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: AppSpace.xl),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          layoutBuilder: (current, previous) => Stack(
            alignment: Alignment.topLeft,
            children: [...previous, ?current],
          ),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween(
                begin: const Offset(0, 0.02),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: _JourneyCard(
            key: ValueKey(_index),
            entry: entry,
            position: _entries.length - _index,
            total: _entries.length,
          ),
        ),
      ],
    );
  }
}

class _YearLabel extends StatelessWidget {
  const _YearLabel({
    required this.year,
    required this.selected,
    required this.onPressed,
  });

  final int year;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onPressed: onPressed,
      radius: 4,
      builder: (context, state) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
        child: Text(
          '$year',
          style: AppText.meta.copyWith(
            fontSize: 11,
            fontWeight: selected ? AppFonts.heading : AppFonts.body,
            color: selected
                ? AppColors.accent300
                : state.active
                ? AppColors.neutral300
                : AppColors.neutral500,
          ),
        ),
      ),
    );
  }
}

class _JourneyCard extends StatelessWidget {
  const _JourneyCard({
    super.key,
    required this.entry,
    required this.position,
    required this.total,
  });

  final JobModel entry;

  /// 1-based position counting from the most recent entry.
  final int position;
  final int total;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final format = DateFormat.yMMM(locale);
    final end = entry.end;
    final range =
        '${format.format(entry.start)} – '
        '${end == null ? l10n.journeyPresent : format.format(end)}';
    String two(int n) => n.toString().padLeft(2, '0');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpace.xl),
      decoration: BoxDecoration(
        color: AppColors.neutral800,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.neutral700),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TagChip(range, variant: TagVariant.accent),
              const Spacer(),
              Text('${two(position)} / ${two(total)}', style: AppText.meta),
            ],
          ),
          const SizedBox(height: AppSpace.lg),
          Text(entry.role, style: AppText.h3),
          if (entry.company != null) ...[
            const SizedBox(height: AppSpace.xxs),
            Text(
              entry.company!,
              style: AppText.bodySmall.copyWith(color: AppColors.neutral400),
            ),
          ],
          if (entry.highlights.isNotEmpty) ...[
            const SizedBox(height: AppSpace.lg),
            for (final h in entry.highlights)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpace.xs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 9, right: AppSpace.md),
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(child: Text(h, style: AppText.body)),
                  ],
                ),
              ),
          ],
          if (entry.tools.isNotEmpty) ...[
            const SizedBox(height: AppSpace.md),
            TagRow(entry.tools),
          ],
        ],
      ),
    );
  }
}
