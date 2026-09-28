import 'package:flutter/material.dart';
import 'package:portfolio/theme/tokens.dart';

enum TagVariant { outline, accent }

/// Small pill label: neutral outline for tools, accent tint for dates/kickers.
class TagChip extends StatelessWidget {
  const TagChip(this.label, {super.key, this.variant = TagVariant.outline});

  final String label;
  final TagVariant variant;

  @override
  Widget build(BuildContext context) {
    final accent = variant == TagVariant.accent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: accent ? AppColors.accent900 : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: accent ? AppColors.accent800 : AppColors.neutral700,
        ),
      ),
      child: Text(
        label,
        style: AppText.tag.copyWith(
          color: accent ? AppColors.accent300 : AppColors.neutral300,
        ),
      ),
    );
  }
}

/// Wrapping row of [TagChip]s.
class TagRow extends StatelessWidget {
  const TagRow(this.tags, {super.key, this.variant = TagVariant.outline});

  final List<String> tags;
  final TagVariant variant;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpace.xs,
      runSpacing: AppSpace.xs,
      children: [for (final t in tags) TagChip(t, variant: variant)],
    );
  }
}
