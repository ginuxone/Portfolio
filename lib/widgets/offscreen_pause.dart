import 'package:flutter/widgets.dart';

/// Tracks whether this widget intersects the screen while its enclosing
/// [Scrollable] moves, so continuous animations can pause when scrolled away.
mixin OffscreenPause<T extends StatefulWidget> on State<T> {
  ScrollPosition? _position;
  bool _onscreen = true;

  bool get onscreen => _onscreen;

  /// Called whenever [onscreen] flips.
  void onVisibilityChanged(bool onscreen);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final position = Scrollable.maybeOf(context)?.position;
    if (position != _position) {
      _position?.removeListener(_check);
      _position = position?..addListener(_check);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void dispose() {
    _position?.removeListener(_check);
    super.dispose();
  }

  void _check() {
    if (!mounted) return;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final visible = top < screenHeight && top + box.size.height > 0;
    if (visible != _onscreen) {
      _onscreen = visible;
      onVisibilityChanged(visible);
    }
  }
}
