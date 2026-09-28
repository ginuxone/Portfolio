import 'package:flutter/material.dart';
import 'package:portfolio/data/profile.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/theme/tokens.dart';
import 'package:portfolio/widgets/section.dart';
import 'package:portfolio/widgets/tech_sphere.dart';

class TechStackSection extends StatelessWidget {
  const TechStackSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final wide = MediaQuery.sizeOf(context).width >= Breakpoints.wide;
    const sphere = TechSphere(items: sphereTech);
    final skills = _SkillList(
      labels: {
        SkillGroup.frontend: l10n.stackFrontend,
        SkillGroup.backend: l10n.stackBackend,
        SkillGroup.cloud: l10n.stackCloud,
      },
    );

    return Section(
      title: l10n.stackTitle,
      meta: l10n.stackMeta(sphereTech.length),
      child: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(child: sphere),
                const SizedBox(width: AppSpace.xxl),
                Expanded(child: skills),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                sphere,
                const SizedBox(height: AppSpace.xl),
                skills,
              ],
            ),
    );
  }
}

class _SkillList extends StatelessWidget {
  const _SkillList({required this.labels});

  final Map<SkillGroup, String> labels;

  @override
  Widget build(BuildContext context) {
    final groups = skillGroups.entries.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < groups.length; i++)
          Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpace.lg),
            decoration: BoxDecoration(
              border: Border(
                top: const BorderSide(color: AppColors.neutral700),
                bottom: i == groups.length - 1
                    ? const BorderSide(color: AppColors.neutral700)
                    : BorderSide.none,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.accent),
                      ),
                    ),
                    const SizedBox(width: AppSpace.sm),
                    Text(
                      labels[groups[i].key]!,
                      style: AppText.meta.copyWith(
                        color: AppColors.accent300,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpace.xs),
                Text(groups[i].value.join(', '), style: AppText.body),
              ],
            ),
          ),
      ],
    );
  }
}
