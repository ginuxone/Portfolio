import 'package:flutter/material.dart';
import 'package:portfolio/data/profile.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/theme/tokens.dart';
import 'package:portfolio/widgets/pressable.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(top: AppSpace.section / 2),
      padding: const EdgeInsets.symmetric(vertical: AppSpace.xxl),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.neutral700)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FooterLink(label: 'GitHub', uri: Profile.github),
              const SizedBox(width: AppSpace.lg),
              const _FooterLink(label: 'LinkedIn', uri: Profile.linkedIn),
            ],
          ),
          const SizedBox(height: AppSpace.md),
          Text(
            l10n.footerCopyright('${DateTime.now().year}'),
            textAlign: TextAlign.center,
            style: AppText.meta,
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.label, required this.uri});

  final String label;
  final Uri? uri;

  @override
  Widget build(BuildContext context) {
    return LinkPressable(
      uri: uri,
      radius: 4,
      builder: (context, state) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          label,
          style: AppText.label.copyWith(
            fontWeight: AppFonts.body,
            color: uri == null
                ? AppColors.neutral500
                : state.active
                ? AppColors.accent300
                : AppColors.neutral300,
          ),
        ),
      ),
    );
  }
}
