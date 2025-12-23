import 'dart:math';
import 'package:flutter/material.dart';

class HeartField extends StatefulWidget {
  final int seed;
  final double density;

  const HeartField({super.key, required this.seed, this.density = 1.0});

  @override
  State<HeartField> createState() => _HeartFieldState();
}

class _HeartFieldState extends State<HeartField> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final List<_Heart> _hearts;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 18))..repeat();
    _hearts = _generate();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  List<_Heart> _generate() {
    final rnd = Random(widget.seed);
    final count = (36 * widget.density).round().clamp(26, 70);
    return List.generate(count, (i) {
      return _Heart(
        x: rnd.nextDouble(),
        y: rnd.nextDouble(),
        size: rnd.nextDouble() * 16 + 10,
        speed: rnd.nextDouble() * 0.35 + 0.18,
        drift: (rnd.nextDouble() - 0.5) * 0.18,
        phase: rnd.nextDouble() * pi * 2,
        hue: rnd.nextDouble(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          return CustomPaint(
            painter: _HeartPainter(t: _c.value, hearts: _hearts),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _Heart {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double drift;
  final double phase;
  final double hue;

  _Heart({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.drift,
    required this.phase,
    required this.hue,
  });
}

class _HeartPainter extends CustomPainter {
  final double t;
  final List<_Heart> hearts;

  _HeartPainter({required this.t, required this.hearts});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final h in hearts) {
      final yy = (h.y - t * h.speed) % 1.1;
      final xWave = sin(t * pi * 2 + h.phase) * 0.012;
      final xx = (h.x + xWave + h.drift * t) % 1.0;

      final p = Offset(xx * size.width, (yy * size.height) - 60);
      final s = h.size * (0.9 + 0.2 * sin(t * pi * 2 + h.phase));

      final c = Color.lerp(const Color(0xFFFF4D8D), const Color(0xFFFFC2D4), h.hue)!;
      paint.color = c.withOpacity(0.12);

      _drawHeart(canvas, p, s, paint);
    }
  }

  void _drawHeart(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    final x = center.dx;
    final y = center.dy;
    path.moveTo(x, y + size * 0.35);
    path.cubicTo(x - size, y - size * 0.25, x - size * 0.25, y - size, x, y - size * 0.45);
    path.cubicTo(x + size * 0.25, y - size, x + size, y - size * 0.25, x, y + size * 0.35);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _HeartPainter oldDelegate) => oldDelegate.t != t;
}
