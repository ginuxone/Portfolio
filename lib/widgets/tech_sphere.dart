import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio/theme/tokens.dart';
import 'package:portfolio/widgets/offscreen_pause.dart';

/// Tag cloud laid out on a Fibonacci sphere, auto-rotating around the Y axis.
///
/// Tags are projected with a simple perspective and always face the viewer
/// (billboarding), scaled and faded by depth. Horizontal drags spin it.
class TechSphere extends StatefulWidget {
  const TechSphere({
    super.key,
    required this.items,
    this.period = const Duration(seconds: 34),
  });

  final List<String> items;

  /// Time for one full revolution.
  final Duration period;

  @override
  State<TechSphere> createState() => _TechSphereState();
}

class _TechSphereState extends State<TechSphere>
    with SingleTickerProviderStateMixin, OffscreenPause {
  static const _tilt = 0.32; // radians around X, gives an orbital feel
  static const _camera = 3.2; // camera distance in sphere radii

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.period,
  );
  late List<_Point3> _points = _fibonacciSphere(widget.items.length);
  double _dragAngle = 0;
  bool _reduceMotion = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context);
    _syncAnimation();
  }

  @override
  void didUpdateWidget(TechSphere oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items.length != widget.items.length) {
      _points = _fibonacciSphere(widget.items.length);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void onVisibilityChanged(bool onscreen) => _syncAnimation();

  void _syncAnimation() {
    final run = !_reduceMotion && onscreen;
    if (run && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!run && _controller.isAnimating) {
      _controller.stop();
    }
  }

  static List<_Point3> _fibonacciSphere(int n) {
    final golden = math.pi * (3 - math.sqrt(5));
    return [
      for (var i = 0; i < n; i++)
        () {
          final y = n == 1 ? 0.0 : 1 - (i / (n - 1)) * 2;
          final r = math.sqrt(1 - y * y);
          final theta = golden * i;
          return _Point3(math.cos(theta) * r, y, math.sin(theta) * r);
        }(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final side = math.min(constraints.maxWidth, 420.0);
        final radius = side * 0.36;
        return Center(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragUpdate: (d) =>
                setState(() => _dragAngle += d.delta.dx * 0.008),
            child: MouseRegion(
              cursor: SystemMouseCursors.grab,
              child: SizedBox.square(
                dimension: side,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) => _buildFrame(side, radius),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFrame(double side, double radius) {
    final angle = _controller.value * 2 * math.pi + _dragAngle;
    final cosA = math.cos(angle), sinA = math.sin(angle);
    final cosT = math.cos(_tilt), sinT = math.sin(_tilt);
    final center = side / 2;

    final projected = <_Projected>[];
    for (var i = 0; i < _points.length; i++) {
      final p = _points[i];
      // Rotate around Y, then tilt around X.
      final x1 = p.x * cosA + p.z * sinA;
      final z1 = -p.x * sinA + p.z * cosA;
      final y2 = p.y * cosT - z1 * sinT;
      final z2 = p.y * sinT + z1 * cosT;
      final scale = _camera / (_camera - z2);
      projected.add(
        _Projected(
          label: widget.items[i],
          x: center + x1 * radius * scale,
          y: center + y2 * radius * scale,
          depth: (z2 + 1) / 2, // 0 = back, 1 = front
          scale: scale,
        ),
      );
    }
    projected.sort((a, b) => a.depth.compareTo(b.depth));

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: CustomPaint(painter: _OrbitPainter(radius, _tilt)),
        ),
        for (final p in projected)
          Positioned(
            left: p.x,
            top: p.y,
            child: FractionalTranslation(
              translation: const Offset(-0.5, -0.5),
              child: Transform.scale(
                scale: p.scale * 0.92,
                child: _SphereTag(label: p.label, depth: p.depth),
              ),
            ),
          ),
      ],
    );
  }
}

class _Point3 {
  const _Point3(this.x, this.y, this.z);
  final double x, y, z;
}

class _Projected {
  const _Projected({
    required this.label,
    required this.x,
    required this.y,
    required this.depth,
    required this.scale,
  });

  final String label;
  final double x, y, depth, scale;
}

class _SphereTag extends StatelessWidget {
  const _SphereTag({required this.label, required this.depth});

  final String label;
  final double depth;

  @override
  Widget build(BuildContext context) {
    final front = depth > 0.62;
    final alpha = 0.3 + 0.7 * depth;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.neutral800.withValues(alpha: 0.4 + 0.5 * depth),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: (front ? AppColors.accent : AppColors.neutral600).withValues(
            alpha: front ? 0.55 * depth : alpha * 0.8,
          ),
        ),
        boxShadow: front
            ? [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.12 * depth),
                  blurRadius: 14,
                ),
              ]
            : null,
      ),
      child: Text(
        label,
        style: AppText.label.copyWith(
          fontSize: 12.5,
          color: (front ? AppColors.accent300 : AppColors.neutral300)
              .withValues(alpha: alpha),
        ),
      ),
    );
  }
}

/// Faint sphere outline and tilted equator behind the tags.
class _OrbitPainter extends CustomPainter {
  _OrbitPainter(this.radius, this.tilt);

  final double radius;
  final double tilt;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    canvas
      ..drawCircle(
        c,
        radius * 1.25,
        Paint()
          ..shader = RadialGradient(
            colors: [
              AppColors.accent.withValues(alpha: 0.08),
              AppColors.accent.withValues(alpha: 0.0),
            ],
          ).createShader(Rect.fromCircle(center: c, radius: radius * 1.25)),
      )
      ..drawCircle(
        c,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = AppColors.neutral700.withValues(alpha: 0.8),
      );
    for (final (scaleY, alpha) in [(math.sin(tilt), 0.28), (0.72, 0.1)]) {
      canvas.drawOval(
        Rect.fromCenter(
          center: c,
          width: radius * 2,
          height: radius * 2 * scaleY,
        ),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = AppColors.accent.withValues(alpha: alpha),
      );
    }
  }

  @override
  bool shouldRepaint(_OrbitPainter oldDelegate) =>
      oldDelegate.radius != radius || oldDelegate.tilt != tilt;
}
