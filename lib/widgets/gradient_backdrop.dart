import 'package:flutter/material.dart';

class GradientBackdrop extends StatefulWidget {
  final bool alt;

  const GradientBackdrop({super.key, this.alt = false});

  @override
  State<GradientBackdrop> createState() => _GradientBackdropState();
}

class _GradientBackdropState extends State<GradientBackdrop> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 7))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        final t = _c.value;
        final a = Alignment.lerp(Alignment.topLeft, Alignment.bottomRight, t)!;
        final b = Alignment.lerp(Alignment.bottomLeft, Alignment.topRight, t)!;

        final colors = widget.alt
            ? const [Color(0xFF170A2A), Color(0xFF4A0B2D), Color(0xFF0B0610)]
            : const [Color(0xFF0B0610), Color(0xFF3A0A2B), Color(0xFF120A1B)];

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: a,
              end: b,
            ),
          ),
        );
      },
    );
  }
}
