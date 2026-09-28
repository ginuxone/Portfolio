import 'package:flutter/material.dart';
import 'package:portfolio/theme/tokens.dart';

OutlineInputBorder _inputBorder(Color color, [double width = 1]) =>
    OutlineInputBorder(
      borderRadius: AppRadius.card,
      borderSide: BorderSide(color: color, width: width),
    );

/// The single (dark) Nocturne theme.
final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  fontFamily: AppFonts.family,
  visualDensity: VisualDensity.compact,
  scaffoldBackgroundColor: AppColors.background,
  canvasColor: AppColors.background,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.accent,
    onPrimary: AppColors.background,
    secondary: AppColors.accent300,
    onSecondary: AppColors.background,
    surface: AppColors.neutral800,
    onSurface: AppColors.text,
    onSurfaceVariant: AppColors.neutral300,
    outline: AppColors.neutral700,
    outlineVariant: AppColors.neutral700,
    error: Color(0xFFE59BA6),
    onError: AppColors.background,
    shadow: AppColors.shadow,
  ),
  // Tint every ripple/hover with the accent at low opacity.
  splashColor: AppColors.accent.withValues(alpha: 0.12),
  highlightColor: AppColors.accent.withValues(alpha: 0.08),
  hoverColor: AppColors.accent.withValues(alpha: 0.06),
  focusColor: AppColors.accent.withValues(alpha: 0.12),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: AppColors.accent300,
    selectionColor: AppColors.accent.withValues(alpha: 0.35),
    selectionHandleColor: AppColors.accent,
  ),
  iconTheme: const IconThemeData(color: AppColors.accent300, size: 18),
  dividerColor: AppColors.neutral700,
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.neutral800,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpace.md,
      vertical: AppSpace.md,
    ),
    labelStyle: AppText.bodySmall,
    floatingLabelStyle: AppText.meta.copyWith(color: AppColors.accent300),
    hintStyle: AppText.bodySmall.copyWith(color: AppColors.neutral500),
    errorStyle: AppText.meta.copyWith(color: const Color(0xFFE59BA6)),
    border: _inputBorder(AppColors.neutral700),
    enabledBorder: _inputBorder(AppColors.neutral700),
    focusedBorder: _inputBorder(AppColors.accent, 1.5),
    errorBorder: _inputBorder(const Color(0xFF8C5360)),
    focusedErrorBorder: _inputBorder(const Color(0xFFE59BA6), 1.5),
  ),
  sliderTheme: SliderThemeData(
    trackHeight: 3,
    activeTrackColor: AppColors.accent,
    inactiveTrackColor: AppColors.neutral700,
    thumbColor: AppColors.accent300,
    overlayColor: AppColors.accent.withValues(alpha: 0.16),
    activeTickMarkColor: AppColors.accent300,
    inactiveTickMarkColor: AppColors.neutral500,
    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
    overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
    tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 2),
    showValueIndicator: ShowValueIndicator.never,
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: AppColors.neutral800,
    textStyle: AppText.label,
    shape: RoundedRectangleBorder(
      borderRadius: AppRadius.card,
      side: const BorderSide(color: AppColors.neutral700),
    ),
  ),
  scrollbarTheme: ScrollbarThemeData(
    thumbColor: WidgetStatePropertyAll(
      AppColors.neutral600.withValues(alpha: 0.8),
    ),
  ),
);
