import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:portfolio/theme/tokens.dart';
import 'package:portfolio/widgets/offscreen_pause.dart';

/// Ambient particle field that forms [text] (the "GM" initials).
///
/// Particles are sampled from a rasterized text mask, drift gently and spring
/// back to their spot in the letterform (Verlet integration). Close particles
/// are joined by faint accent lines. Pointer movement pushes particles away.
class ParticleHero extends StatefulWidget {
  const ParticleHero({
    super.key,
    this.text = 'GM',
    this.maxParticles = 380,
    this.pointer,
  });

  final String text;
  final int maxParticles;

  /// Pointer position in this widget's coordinates, or null when outside.
  final ValueListenable<Offset?>? pointer;

  @override
  State<ParticleHero> createState() => _ParticleHeroState();
}

class _ParticleHeroState extends State<ParticleHero>
    with SingleTickerProviderStateMixin, OffscreenPause {
  late final Ticker _ticker = createTicker(_tick);
  final _sim = _ParticleSim();
  Duration? _lastElapsed;
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    widget.pointer?.addListener(_onPointer);
    _loadMask();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context);
    _syncTicker();
  }

  @override
  void didUpdateWidget(ParticleHero oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pointer != widget.pointer) {
      oldWidget.pointer?.removeListener(_onPointer);
      widget.pointer?.addListener(_onPointer);
    }
  }

  @override
  void dispose() {
    widget.pointer?.removeListener(_onPointer);
    _ticker.dispose();
    _sim.dispose();
    super.dispose();
  }

  @override
  void onVisibilityChanged(bool onscreen) => _syncTicker();

  void _onPointer() => _sim.pointer = widget.pointer?.value;

  void _syncTicker() {
    final run = _sim.hasMask && !_reduceMotion && onscreen;
    if (run && !_ticker.isActive) {
      _lastElapsed = null;
      _ticker.start();
    } else if (!run && _ticker.isActive) {
      _ticker.stop();
    }
    if (_reduceMotion) _sim.settle();
  }

  void _tick(Duration elapsed) {
    final last = _lastElapsed;
    _lastElapsed = elapsed;
    if (last == null) return;
    // Clamp so a dropped frame or a background tab can't explode the physics.
    final dt = ((elapsed - last).inMicroseconds / 1e6).clamp(0.0, 1 / 30);
    _sim.step(dt);
  }

  Future<void> _loadMask() async {
    final mask = await _TextMask.rasterize(widget.text);
    if (!mounted || mask == null) return;
    // Rebuild so the target rect picks up the mask's real aspect ratio.
    setState(() => _sim.setMask(mask, widget.maxParticles));
    _syncTicker();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        _sim.layout(size, _targetRect(size));
        return RepaintBoundary(
          child: CustomPaint(size: size, painter: _ParticlePainter(_sim)),
        );
      },
    );
  }

  /// Where the letterform sits: right half on wide screens, centered behind
  /// the copy on narrow ones.
  Rect _targetRect(Size size) {
    final aspect = _sim.maskAspect;
    if (size.width >= Breakpoints.wide) {
      final w = math.min(size.width * 0.44, 600.0);
      final h = w / aspect;
      final right = size.width - math.max(size.width * 0.06, AppSpace.xxl);
      return Rect.fromLTWH(right - w, (size.height - h) / 2 + 24, w, h);
    }
    final w = size.width * 0.84;
    final h = w / aspect;
    return Rect.fromLTWH(
      (size.width - w) / 2,
      size.height * 0.2,
      w,
      math.min(h, size.height * 0.5),
    );
  }
}

/// Points sampled from the rasterized text, normalized to its bounding box.
class _TextMask {
  _TextMask(this.points, this.aspect, this.fill);

  final List<Offset> points;
  final double aspect;

  /// Fraction of the bounding box covered by the glyphs.
  final double fill;

  static const _w = 640;
  static const _h = 320;
  static const _step = 3;

  static Future<_TextMask?> rasterize(String text) async {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontFamily: AppFonts.family,
          fontSize: 260,
          fontWeight: AppFonts.heading,
          letterSpacing: -8,
          color: Color(0xFFFFFFFF), // offscreen mask only, never displayed
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final scale = math.min(
      _w * 0.94 / painter.width,
      _h * 0.94 / painter.height,
    );
    canvas
      ..translate(
        (_w - painter.width * scale) / 2,
        (_h - painter.height * scale) / 2,
      )
      ..scale(scale);
    painter.paint(canvas, Offset.zero);
    painter.dispose();

    final picture = recorder.endRecording();
    final image = await picture.toImage(_w, _h);
    picture.dispose();
    final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    image.dispose();
    if (data == null) return null;

    final raw = <Offset>[];
    var minX = _w, minY = _h, maxX = 0, maxY = 0;
    for (var y = 0; y < _h; y += _step) {
      for (var x = 0; x < _w; x += _step) {
        if (data.getUint8((y * _w + x) * 4 + 3) > 140) {
          raw.add(Offset(x.toDouble(), y.toDouble()));
          minX = math.min(minX, x);
          maxX = math.max(maxX, x);
          minY = math.min(minY, y);
          maxY = math.max(maxY, y);
        }
      }
    }
    if (raw.isEmpty) return null;

    final bw = math.max(1, maxX - minX).toDouble();
    final bh = math.max(1, maxY - minY).toDouble();
    final fill = raw.length * _step * _step / (bw * bh);
    return _TextMask(
      [for (final p in raw) Offset((p.dx - minX) / bw, (p.dy - minY) / bh)],
      bw / bh,
      fill,
    );
  }
}

class _Particle {
  _Particle(this.x, this.y, this.phase, this.bright) : px = x, py = y;

  double x, y; // current position
  double px, py; // previous position (Verlet)
  double hx = 0, hy = 0; // home in the letterform
  final double phase;
  final bool bright;
}

class _ParticleSim extends ChangeNotifier {
  static const _stiffness = 26.0; // spring toward home, 1/s²
  static const _damping = 0.9; // velocity kept per frame
  static const _kickChance = 0.004; // per particle per frame
  static const _pointerRadius = 90.0;

  final _random = math.Random(7);
  final List<_Particle> particles = [];
  List<Offset> _homes = const [];
  double maskAspect = 2.0;
  double _fill = 0.4;
  double _time = 0;
  Size _size = Size.zero;
  Rect _rect = Rect.zero;
  Offset? pointer;

  /// Typical distance between neighbouring particles, in pixels.
  double spacing = 12;

  bool get hasMask => _homes.isNotEmpty;

  void setMask(_TextMask mask, int maxParticles) {
    final points = [...mask.points]..shuffle(_random);
    _homes = points.take(maxParticles).toList();
    maskAspect = mask.aspect;
    _fill = mask.fill;
    particles
      ..clear()
      ..addAll([
        for (var i = 0; i < _homes.length; i++)
          // Start scattered across the canvas; the springs pull them in.
          _Particle(
            _random.nextDouble() * math.max(_size.width, 1),
            _random.nextDouble() * math.max(_size.height, 1),
            _random.nextDouble() * math.pi * 2,
            i % 4 == 0,
          ),
      ]);
    _applyHomes();
    notifyListeners();
  }

  void layout(Size size, Rect rect) {
    if (size == _size && rect == _rect) return;
    _size = size;
    _rect = rect;
    _applyHomes();
  }

  void _applyHomes() {
    for (var i = 0; i < particles.length; i++) {
      final h = _homes[i];
      particles[i]
        ..hx = _rect.left + h.dx * _rect.width
        ..hy = _rect.top + h.dy * _rect.height;
    }
    if (particles.isNotEmpty) {
      spacing = math.sqrt(
        _rect.width * _rect.height * _fill / particles.length,
      );
    }
  }

  /// Snaps every particle home (used when motion is reduced).
  void settle() {
    for (final p in particles) {
      p
        ..x = p.hx
        ..y = p.hy
        ..px = p.hx
        ..py = p.hy;
    }
    notifyListeners();
  }

  void step(double dt) {
    _time += dt;
    final amp = spacing * 0.45;
    final dt2 = dt * dt;
    final ptr = pointer;
    for (final p in particles) {
      // Gentle drift around home, then spring back toward it.
      final tx = p.hx + math.sin(_time * 0.7 + p.phase) * amp;
      final ty = p.hy + math.cos(_time * 0.9 + p.phase * 1.3) * amp;
      var ax = (tx - p.x) * _stiffness;
      var ay = (ty - p.y) * _stiffness;

      if (ptr != null) {
        final dx = p.x - ptr.dx;
        final dy = p.y - ptr.dy;
        final d2 = dx * dx + dy * dy;
        if (d2 < _pointerRadius * _pointerRadius && d2 > 0.01) {
          final d = math.sqrt(d2);
          final force = (1 - d / _pointerRadius) * 2600;
          ax += dx / d * force;
          ay += dy / d * force;
        }
      }

      var vx = (p.x - p.px) * _damping;
      var vy = (p.y - p.py) * _damping;
      // Occasional small kick so the shape never looks frozen.
      if (_random.nextDouble() < _kickChance) {
        vx += (_random.nextDouble() - 0.5) * spacing * 0.5;
        vy += (_random.nextDouble() - 0.5) * spacing * 0.5;
      }

      p
        ..px = p.x
        ..py = p.y
        ..x = p.x + vx + ax * dt2
        ..y = p.y + vy + ay * dt2;
    }
    notifyListeners();
  }
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter(this.sim) : super(repaint: sim);

  final _ParticleSim sim;

  static final _glow = Paint();
  static final _dot = Paint()
    ..strokeCap = StrokeCap.round
    ..color = AppColors.accent.withValues(alpha: 0.75)
    ..strokeWidth = 2.0;
  static final _dotBright = Paint()
    ..strokeCap = StrokeCap.round
    ..color = AppColors.accent300.withValues(alpha: 0.9)
    ..strokeWidth = 2.6;
  static final _linePaints = [
    for (final a in const [0.22, 0.13, 0.06])
      Paint()
        ..strokeWidth = 0.7
        ..color = AppColors.accent.withValues(alpha: a),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final ps = sim.particles;
    if (ps.isEmpty) return;

    // Soft ambient glow behind the letterform.
    final c = Offset(
      ps.fold<double>(0, (s, p) => s + p.hx) / ps.length,
      ps.fold<double>(0, (s, p) => s + p.hy) / ps.length,
    );
    final r = size.shortestSide * 0.55;
    _glow.shader = ui.Gradient.radial(c, r, [
      AppColors.accent.withValues(alpha: 0.10),
      AppColors.accent.withValues(alpha: 0.0),
    ]);
    canvas.drawCircle(c, r, _glow);

    // Connect near neighbours, bucketed by distance into three opacities.
    final maxD = sim.spacing * 1.7;
    final maxD2 = maxD * maxD;
    final buckets = [<double>[], <double>[], <double>[]];
    for (var i = 0; i < ps.length; i++) {
      final a = ps[i];
      for (var j = i + 1; j < ps.length; j++) {
        final b = ps[j];
        final dx = a.x - b.x;
        if (dx > maxD || dx < -maxD) continue;
        final dy = a.y - b.y;
        if (dy > maxD || dy < -maxD) continue;
        final d2 = dx * dx + dy * dy;
        if (d2 > maxD2) continue;
        final t = d2 / maxD2;
        buckets[t < 0.3 ? 0 : (t < 0.65 ? 1 : 2)].addAll([a.x, a.y, b.x, b.y]);
      }
    }
    for (var k = 0; k < buckets.length; k++) {
      if (buckets[k].isEmpty) continue;
      canvas.drawRawPoints(
        ui.PointMode.lines,
        Float32List.fromList(buckets[k]),
        _linePaints[k],
      );
    }

    final dim = <double>[];
    final bright = <double>[];
    for (final p in ps) {
      (p.bright ? bright : dim).addAll([p.x, p.y]);
    }
    canvas
      ..drawRawPoints(ui.PointMode.points, Float32List.fromList(dim), _dot)
      ..drawRawPoints(
        ui.PointMode.points,
        Float32List.fromList(bright),
        _dotBright,
      );
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) => oldDelegate.sim != sim;
}
