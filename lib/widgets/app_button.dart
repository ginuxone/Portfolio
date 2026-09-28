import 'package:flutter/material.dart';
import 'package:portfolio/theme/tokens.dart';
import 'package:portfolio/widgets/pressable.dart';

enum AppButtonVariant { primary, secondary }

/// Outline button. Primary is an accent outline with accent text (never
/// filled); secondary is a neutral outline.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onPressed: onPressed,
      builder: (context, state) {
        final primary = variant == AppButtonVariant.primary;
        final Color border;
        final Color fill;
        final Color foreground;
        if (primary) {
          border = state.active ? AppColors.accent300 : AppColors.accent;
          fill = state.pressed
              ? AppColors.accent800
              : state.active
              ? AppColors.accent900
              : Colors.transparent;
          foreground = AppColors.accent300;
        } else {
          border = state.active ? AppColors.accent600 : AppColors.neutral600;
          fill = state.pressed
              ? AppColors.accent900
              : state.active
              ? AppColors.neutral800
              : Colors.transparent;
          foreground = AppColors.text;
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          height: 38,
          width: expand ? double.infinity : null,
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
          decoration: BoxDecoration(
            color: fill,
            borderRadius: AppRadius.card,
            border: Border.all(color: border),
          ),
          child: Row(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: AppText.label.copyWith(color: foreground)),
              if (icon != null) ...[
                const SizedBox(width: AppSpace.xs),
                Icon(icon, size: 15, color: foreground),
              ],
            ],
          ),
        );
      },
    );
  }
}
