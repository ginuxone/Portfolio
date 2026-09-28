import 'package:flutter/material.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/sections/contact_section.dart';
import 'package:portfolio/sections/hero_section.dart';
import 'package:portfolio/sections/journey_section.dart';
import 'package:portfolio/sections/projects_section.dart';
import 'package:portfolio/sections/site_footer.dart';
import 'package:portfolio/sections/tech_stack_section.dart';
import 'package:portfolio/theme/tokens.dart';
import 'package:portfolio/widgets/top_nav.dart';

/// The single-page site: all sections in one scroll view under a sticky nav.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scroll = ScrollController();
  final _scrolled = ValueNotifier(false);
  final _stackKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _journeyKey = GlobalKey();
  final _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() => _scrolled.value = _scroll.offset > 8);
  }

  @override
  void dispose() {
    _scroll.dispose();
    _scrolled.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    // Land the section just below the sticky nav.
    final target =
        _scroll.offset +
        box.localToGlobal(Offset.zero).dy -
        AppSpace.navHeight +
        AppSpace.md;
    _animateTo(target);
  }

  void _animateTo(double offset) {
    final position = _scroll.position;
    final target = offset.clamp(0.0, position.maxScrollExtent);
    if (MediaQuery.disableAnimationsOf(context)) {
      _scroll.jumpTo(target);
    } else {
      _scroll.animateTo(
        target,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _scroll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HeroSection(
                    onViewProjects: () => _scrollTo(_projectsKey),
                    onGetInTouch: () => _scrollTo(_contactKey),
                  ),
                  TechStackSection(key: _stackKey),
                  ProjectsSection(key: _projectsKey),
                  JourneySection(key: _journeyKey),
                  ContactSection(key: _contactKey),
                  const SiteFooter(),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ValueListenableBuilder(
              valueListenable: _scrolled,
              builder: (context, scrolled, _) => TopNav(
                scrolled: scrolled,
                onHome: () => _animateTo(0),
                homeLabel: l10n.navHome,
                menuLabel: l10n.navMenu,
                items: [
                  NavItem(l10n.navStack, () => _scrollTo(_stackKey)),
                  NavItem(l10n.navProjects, () => _scrollTo(_projectsKey)),
                  NavItem(l10n.navJourney, () => _scrollTo(_journeyKey)),
                  NavItem(l10n.navContact, () => _scrollTo(_contactKey)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
