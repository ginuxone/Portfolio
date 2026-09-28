import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio/data/projects.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/models/project_model.dart';
import 'package:portfolio/theme/tokens.dart';
import 'package:portfolio/widgets/glass_card.dart';
import 'package:portfolio/widgets/pressable.dart';
import 'package:portfolio/widgets/section.dart';
import 'package:portfolio/widgets/tag_chip.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  static const _minCardWidth = 280.0;
  static const _gap = AppSpace.lg;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Stack(
      children: [
        // Soft glows behind the grid give the glass something to blur.
        const Positioned.fill(child: IgnorePointer(child: _BackdropGlows())),
        Section(
          title: l10n.projectsTitle,
          meta: l10n.projectsMeta,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final columns = _columns(constraints.maxWidth, projects.length);
              final rows = <List<ProjectModel>>[
                for (var i = 0; i < projects.length; i += columns)
                  projects.sublist(i, math.min(i + columns, projects.length)),
              ];
              return Column(
                children: [
                  for (final row in rows)
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: row == rows.last ? 0 : _gap,
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (var c = 0; c < columns; c++) ...[
                              if (c > 0) const SizedBox(width: _gap),
                              Expanded(
                                child: c < row.length
                                    ? _ProjectCard(
                                        project: row[c],
                                        index: projects.indexOf(row[c]),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  /// Auto-fit columns of at least [_minCardWidth], preferring a count that
  /// divides [count] evenly (e.g. 2x2 rather than 3+1).
  static int _columns(double width, int count) {
    final fit = math.max(1, ((width + _gap) / (_minCardWidth + _gap)).floor());
    final max = math.min(fit, count);
    for (var c = max; c > 1; c--) {
      if (count % c == 0) return c;
    }
    return max;
  }
}

class _BackdropGlows extends StatelessWidget {
  const _BackdropGlows();

  @override
  Widget build(BuildContext context) {
    Widget glow(Color color, double size) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
      ),
    );
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Align(
          alignment: const Alignment(-0.7, 0.1),
          child: glow(AppColors.accent.withValues(alpha: 0.22), 420),
        ),
        Align(
          alignment: const Alignment(0.8, 0.7),
          child: glow(const Color(0xFF5B7BD9).withValues(alpha: 0.14), 360),
        ),
      ],
    );
  }
}

class _ProjectCard extends StatefulWidget {
  const _ProjectCard({required this.project, required this.index});

  final ProjectModel project;
  final int index;

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GlassCard(
        highlighted: _hovered,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 170,
              child: _ProjectPreview(project: p, index: widget.index),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpace.lg,
                AppSpace.sm,
                AppSpace.lg,
                AppSpace.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: Text(p.title, style: AppText.cardTitle)),
                      const SizedBox(width: AppSpace.sm),
                      _DomainLink(project: p),
                    ],
                  ),
                  const SizedBox(height: AppSpace.xs),
                  Text(
                    p.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodySmall,
                  ),
                  const SizedBox(height: AppSpace.md),
                  TagRow(p.tags),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DomainLink extends StatelessWidget {
  const _DomainLink({required this.project});

  final ProjectModel project;

  @override
  Widget build(BuildContext context) {
    return LinkPressable(
      uri: project.url,
      radius: 4,
      semanticLabel: '${project.title}: ${project.domain}',
      builder: (context, state) {
        final color = state.active ? AppColors.accent300 : AppColors.neutral400;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(project.domain, style: AppText.meta.copyWith(color: color)),
              const SizedBox(width: 3),
              Icon(Icons.north_east_rounded, size: 12, color: color),
            ],
          ),
        );
      },
    );
  }
}

/// Screenshot area. Until real screenshots are added it renders an abstract
/// browser-window preview; either way it fades into the card at the bottom.
class _ProjectPreview extends StatelessWidget {
  const _ProjectPreview({required this.project, required this.index});

  final ProjectModel project;
  final int index;

  @override
  Widget build(BuildContext context) {
    final asset = project.imageAsset;
    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (rect) => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.55, 1],
        colors: [Color(0xFF161826), Color(0x00161826)],
      ).createShader(rect),
      child: asset != null
          ? Image.asset(
              asset,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            )
          : _placeholder(),
    );
  }

  Widget _placeholder() {
    final glowAt = [
      const Alignment(-0.8, -0.6),
      const Alignment(0.8, -0.4),
      const Alignment(-0.3, 0.9),
      const Alignment(0.6, 0.8),
    ][index % 4];
    final initials = project.title
        .split(' ')
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0])
        .join();

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: glowAt,
          radius: 1.2,
          colors: [
            AppColors.accent.withValues(alpha: 0.35),
            AppColors.accent900,
            AppColors.neutral800,
          ],
          stops: const [0, 0.5, 1],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpace.lg,
          AppSpace.lg,
          AppSpace.lg,
          0,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.55),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpace.sm),
                child: Row(
                  children: [
                    for (var i = 0; i < 3; i++)
                      Container(
                        margin: const EdgeInsets.only(right: 4),
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.neutral600,
                          shape: BoxShape.circle,
                        ),
                      ),
                    const SizedBox(width: AppSpace.sm),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.neutral800,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Text(
                          project.domain,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.tag.copyWith(
                            fontSize: 10,
                            color: AppColors.neutral400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    initials,
                    style: AppText.h2.copyWith(
                      fontSize: 44,
                      letterSpacing: 2,
                      color: AppColors.accent300.withValues(alpha: 0.55),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
