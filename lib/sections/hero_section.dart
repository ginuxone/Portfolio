import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio/data/profile.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/theme/tokens.dart';
import 'package:portfolio/widgets/app_button.dart';
import 'package:portfolio/widgets/particle_hero.dart';
import 'package:portfolio/widgets/section.dart';
import 'package:portfolio/widgets/tag_chip.dart';

/// Full-bleed hero: particle "GM" field behind left-aligned intro copy.
class HeroSection extends StatefulWidget {
  const HeroSection({
    super.key,
    required this.onViewProjects,
    required this.onGetInTouch,
  });

  final VoidCallback onViewProjects;
  final VoidCallback onGetInTouch;

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  final _pointer = ValueNotifier<Offset?>(null);

  @override
  void dispose() {
    _pointer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screen = MediaQuery.sizeOf(context);
    final wide = screen.width >= Breakpoints.wide;
    final height = math.max(screen.height.clamp(0.0, 880.0), 580.0);

    return MouseRegion(
      opaque: false,
      onHover: (e) => _pointer.value = e.localPosition,
      onExit: (_) => _pointer.value = null,
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: wide ? 1 : 0.45,
                child: ParticleHero(text: Profile.initials, pointer: _pointer),
              ),
            ),
            // Fade the field into the next section.
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 120,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x00161826), AppColors.background],
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              top: AppSpace.navHeight,
              child: ContentWidth(
                child: Align(
                  alignment: wide ? Alignment.centerLeft : Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: wide ? 0 : AppSpace.section,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TagChip(l10n.heroKicker),
                          const SizedBox(height: AppSpace.lg),
                          Semantics(
                            header: true,
                            child: Text(
                              Profile.name,
                              style: AppText.hero(screen.width),
                            ),
                          ),
                          const SizedBox(height: AppSpace.lg),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 460),
                            child: Text(
                              l10n.heroSubtitle,
                              style: AppText.body.copyWith(fontSize: 15),
                            ),
                          ),
                          const SizedBox(height: AppSpace.xl),
                          Wrap(
                            spacing: AppSpace.md,
                            runSpacing: AppSpace.md,
                            children: [
                              AppButton(
                                label: l10n.heroViewProjects,
                                icon: Icons.arrow_downward_rounded,
                                onPressed: widget.onViewProjects,
                              ),
                              AppButton(
                                label: l10n.heroGetInTouch,
                                variant: AppButtonVariant.secondary,
                                onPressed: widget.onGetInTouch,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
