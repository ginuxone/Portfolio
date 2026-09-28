import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:portfolio/data/profile.dart';
import 'package:portfolio/theme/tokens.dart';
import 'package:portfolio/widgets/pressable.dart';
import 'package:portfolio/widgets/section.dart';

class NavItem {
  const NavItem(this.label, this.onSelected);

  final String label;
  final VoidCallback onSelected;
}

/// Sticky top bar: "GM" wordmark and section links. Transparent over the
/// hero, blurred and translucent once the page has scrolled.
class TopNav extends StatelessWidget {
  const TopNav({
    super.key,
    required this.scrolled,
    required this.items,
    required this.onHome,
    required this.homeLabel,
    required this.menuLabel,
  });

  final bool scrolled;
  final List<NavItem> items;
  final VoidCallback onHome;
  final String homeLabel;
  final String menuLabel;

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < Breakpoints.narrow;
    final bar = AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      height: AppSpace.navHeight,
      decoration: BoxDecoration(
        color: scrolled
            ? AppColors.background.withValues(alpha: 0.72)
            : AppColors.background.withValues(alpha: 0.0),
        border: Border(
          bottom: BorderSide(
            color: scrolled
                ? AppColors.neutral700.withValues(alpha: 0.8)
                : AppColors.neutral700.withValues(alpha: 0.0),
          ),
        ),
      ),
      child: ContentWidth(
        child: Row(
          children: [
            _Wordmark(onPressed: onHome, label: homeLabel),
            const Spacer(),
            if (narrow)
              _NavMenu(items: items, tooltip: menuLabel)
            else
              for (final item in items) ...[
                const SizedBox(width: AppSpace.xs),
                _NavLink(item: item),
              ],
          ],
        ),
      ),
    );

    return ClipRect(
      child: BackdropFilter(
        enabled: scrolled,
        filter: ui.ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: bar,
      ),
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark({required this.onPressed, required this.label});

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onPressed: onPressed,
      radius: 6,
      semanticLabel: label,
      builder: (context, state) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: state.active ? AppColors.accent : AppColors.neutral600,
          ),
        ),
        child: Text(
          Profile.initials,
          style: AppText.label.copyWith(
            fontSize: 14,
            letterSpacing: 1.5,
            color: state.active ? AppColors.accent300 : AppColors.text,
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({required this.item});

  final NavItem item;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onPressed: item.onSelected,
      radius: 6,
      builder: (context, state) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.label,
              style: AppText.label.copyWith(
                fontWeight: AppFonts.body,
                color: state.active ? AppColors.text : AppColors.neutral300,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              height: 1,
              width: state.active ? 16 : 0,
              color: AppColors.accent,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavMenu extends StatelessWidget {
  const _NavMenu({required this.items, required this.tooltip});

  final List<NavItem> items;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<NavItem>(
      tooltip: tooltip,
      icon: const Icon(Icons.menu_rounded, color: AppColors.accent300),
      position: PopupMenuPosition.under,
      onSelected: (item) => item.onSelected(),
      itemBuilder: (context) => [
        for (final item in items)
          PopupMenuItem(value: item, height: 40, child: Text(item.label)),
      ],
    );
  }
}
