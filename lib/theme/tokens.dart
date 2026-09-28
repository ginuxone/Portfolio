import 'package:flutter/material.dart';

/// Nocturne design tokens: dark, quiet, compact.
///
/// No pure black or white is used anywhere; the accent is reserved for
/// lines, glows, icons and text, never for large filled areas.
abstract final class AppColors {
  static const background = Color(0xFF161826);
  static const text = Color(0xFFE9E9ED);

  // Neutral ramp (dark -> light usage).
  static const neutral800 = Color(0xFF1F2233); // surfaces
  static const neutral700 = Color(0xFF2A2E42); // borders
  static const neutral600 = Color(0xFF3A3F59);
  static const neutral500 = Color(0xFF585E7A); // muted lines, inactive labels
  static const neutral400 = Color(0xFF7A7F9C); // meta text
  static const neutral300 = Color(0xFFB6B9CC); // secondary text

  // Accent ramp (blurple).
  static const accent = Color(0xFF9184D9);
  static const accent900 = Color(0xFF1E1B36); // dark tint fills
  static const accent800 = Color(0xFF2C2752); // dark tint borders
  static const accent600 = Color(0xFF7A6DC7); // hover
  static const accent300 = Color(0xFFC6BEF2); // accent text on dark bg

  /// Ambient shadow color: deep background tone, never black.
  static const shadow = Color(0xFF0A0B14);
}

abstract final class AppFonts {
  static const family = 'Inter';
  static const heading = FontWeight.w500; // never bolder
  static const body = FontWeight.w400;
}

abstract final class AppText {
  /// Hero H1 scales between 36 and 64px with the viewport width.
  static TextStyle hero(double viewportWidth) => TextStyle(
    fontFamily: AppFonts.family,
    fontSize: (viewportWidth * 0.055).clamp(36.0, 64.0),
    fontWeight: AppFonts.heading,
    height: 1.05,
    letterSpacing: -1.2,
    color: AppColors.text,
  );

  static const h2 = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 32,
    fontWeight: AppFonts.heading,
    height: 1.15,
    letterSpacing: -0.6,
    color: AppColors.text,
  );

  static const h3 = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 20,
    fontWeight: AppFonts.heading,
    height: 1.25,
    letterSpacing: -0.2,
    color: AppColors.text,
  );

  static const cardTitle = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 17,
    fontWeight: AppFonts.heading,
    height: 1.3,
    color: AppColors.text,
  );

  static const body = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 14,
    fontWeight: AppFonts.body,
    height: 1.6,
    color: AppColors.neutral300,
  );

  static const bodySmall = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 13.5,
    fontWeight: AppFonts.body,
    height: 1.55,
    color: AppColors.neutral300,
  );

  static const meta = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 12,
    fontWeight: AppFonts.body,
    height: 1.4,
    letterSpacing: 0.2,
    color: AppColors.neutral400,
  );

  static const label = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 13,
    fontWeight: AppFonts.heading,
    height: 1.2,
    letterSpacing: 0.1,
    color: AppColors.text,
  );

  static const tag = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 11,
    fontWeight: AppFonts.heading,
    height: 1.2,
    letterSpacing: 0.3,
    color: AppColors.neutral300,
  );
}

/// Compact spacing scale (~0.7x regular Material spacing).
abstract final class AppSpace {
  static const xxs = 3.0;
  static const xs = 6.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 22.0;
  static const xxl = 32.0;
  static const section = 88.0;

  static const maxContentWidth = 1120.0;
  static const navHeight = 56.0;
}

abstract final class AppRadius {
  static const base = 8.0;
  static const pill = 999.0;
  static final card = BorderRadius.circular(base);
}

/// Soft, single-layer shadows: edge + ambient darkness only.
abstract final class AppShadows {
  static const sm = [
    BoxShadow(color: Color(0x590A0B14), blurRadius: 6, offset: Offset(0, 2)),
  ];
  static const md = [
    BoxShadow(color: Color(0x730A0B14), blurRadius: 18, offset: Offset(0, 8)),
  ];
  static const lg = [
    BoxShadow(color: Color(0x8C0A0B14), blurRadius: 40, offset: Offset(0, 18)),
  ];
}

/// Responsive breakpoints.
abstract final class Breakpoints {
  static const wide = 900.0;
  static const narrow = 600.0;
}
