import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/theme/tokens.dart';
import 'package:url_launcher/link.dart';

/// Interaction state handed to a [Pressable] builder.
class PressState {
  const PressState({
    this.hovered = false,
    this.pressed = false,
    this.focused = false,
  });

  final bool hovered;
  final bool pressed;
  final bool focused;

  bool get active => hovered || focused;
}

/// Base for every custom interactive element: keyboard activation, hover and
/// pressed states, and the Nocturne focus ring (2px accent, 2px offset)
/// instead of Material's default highlight.
class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    required this.onPressed,
    required this.builder,
    this.radius = AppRadius.base,
    this.isLink = false,
    this.semanticLabel,
  });

  final VoidCallback? onPressed;
  final Widget Function(BuildContext context, PressState state) builder;

  /// Corner radius of the child, used to round the focus ring around it.
  final double radius;
  final bool isLink;
  final String? semanticLabel;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final state = PressState(
      hovered: _hovered,
      pressed: _pressed,
      focused: _focused,
    );

    return Semantics(
      button: !widget.isLink,
      link: widget.isLink,
      enabled: enabled,
      label: widget.semanticLabel,
      child: FocusableActionDetector(
        enabled: enabled,
        mouseCursor: enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onShowHoverHighlight: (v) => setState(() => _hovered = v),
        onShowFocusHighlight: (v) => setState(() => _focused = v),
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onPressed?.call();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onPressed,
          onTapDown: enabled ? (_) => _setPressed(true) : null,
          onTapUp: enabled ? (_) => _setPressed(false) : null,
          onTapCancel: enabled ? () => _setPressed(false) : null,
          child: FocusRing(
            visible: _focused,
            radius: widget.radius,
            child: widget.builder(context, state),
          ),
        ),
      ),
    );
  }
}

/// Draws the 2px accent focus ring, offset 2px outside [child], without
/// affecting layout.
class FocusRing extends StatelessWidget {
  const FocusRing({
    super.key,
    required this.visible,
    required this.child,
    this.radius = AppRadius.base,
  });

  static const _offset = 2.0;
  static const _width = 2.0;

  final bool visible;
  final double radius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    const inset = -(_offset + _width);
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.passthrough,
      children: [
        child,
        if (visible)
          Positioned(
            left: inset,
            top: inset,
            right: inset,
            bottom: inset,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    radius + _offset + _width,
                  ),
                  border: Border.all(color: AppColors.accent, width: _width),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// A [Pressable] that opens [uri] (a real anchor on the web).
///
/// When [uri] is null the element renders disabled, which keeps placeholder
/// links visible without pointing anywhere.
class LinkPressable extends StatelessWidget {
  const LinkPressable({
    super.key,
    required this.uri,
    required this.builder,
    this.radius = AppRadius.base,
    this.newTab = true,
    this.semanticLabel,
  });

  final Uri? uri;
  final Widget Function(BuildContext context, PressState state) builder;
  final double radius;
  final bool newTab;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final target = uri;
    if (target == null) {
      return Pressable(
        onPressed: null,
        radius: radius,
        isLink: true,
        semanticLabel: semanticLabel,
        builder: builder,
      );
    }
    return Link(
      uri: target,
      target: newTab ? LinkTarget.blank : LinkTarget.self,
      builder: (context, followLink) => Pressable(
        onPressed: followLink,
        radius: radius,
        isLink: true,
        semanticLabel: semanticLabel,
        builder: builder,
      ),
    );
  }
}
