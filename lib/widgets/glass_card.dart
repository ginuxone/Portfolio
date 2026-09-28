import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:portfolio/theme/tokens.dart';

/// Frosted surface: backdrop blur + saturation, translucent neutral fill,
/// hairline accent border and a soft single-layer shadow.
///
/// Lifts slightly and brightens its border while [highlighted].
class GlassCard extends StatelessWidget {
  const GlassCard({super.key, required this.child, this.highlighted = false});

  final Widget child;
  final bool highlighted;

  // Luminance-preserving saturation boost (s = 1.4) applied under the blur.
  static const _saturate = ColorFilter.matrix(<double>[
    1.31496, -0.28608, -0.02888, 0, 0, //
    -0.08504, 1.11392, -0.02888, 0, 0, //
    -0.08504, -0.28608, 1.37112, 0, 0, //
    0, 0, 0, 1, 0, //
  ]);

  static final _filter = ui.ImageFilter.compose(
    outer: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
    inner: _saturate,
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      transform: Matrix4.translationValues(0, highlighted ? -3 : 0, 0),
      decoration: BoxDecoration(
        borderRadius: AppRadius.card,
        boxShadow: highlighted ? AppShadows.lg : AppShadows.md,
      ),
      child: ClipRRect(
        borderRadius: AppRadius.card,
        child: BackdropFilter(
          filter: _filter,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: AppColors.neutral800.withValues(alpha: 0.55),
              borderRadius: AppRadius.card,
              border: Border.all(
                color: AppColors.accent.withValues(
                  alpha: highlighted ? 0.45 : 0.18,
                ),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
