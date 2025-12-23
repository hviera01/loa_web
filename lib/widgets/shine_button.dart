import 'package:flutter/material.dart';

class ShineButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final bool compact;

  const ShineButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
    this.compact = false,
  });

  @override
  State<ShineButton> createState() => _ShineButtonState();
}

class _ShineButtonState extends State<ShineButton> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1300))..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pad = widget.compact ? const EdgeInsets.symmetric(horizontal: 14, vertical: 12) : const EdgeInsets.symmetric(horizontal: 16, vertical: 14);
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, __) {
          final t = _c.value;
          return Container(
            padding: pad,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: [Color(0xFFFF4D8D), Color(0xFFFFC2D4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(color: const Color(0xFFFF4D8D).withOpacity(0.35), blurRadius: 22, offset: const Offset(0, 14)),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: CustomPaint(
                      painter: _ShinePainter(t: t),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(widget.icon, color: Colors.black.withOpacity(0.85)),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        widget.text,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.85),
                          fontWeight: FontWeight.w900,
                          fontSize: widget.compact ? 14 : 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ShinePainter extends CustomPainter {
  final double t;

  _ShinePainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint();
    final x = (t * 1.6 - 0.3) * size.width;
    final rect = Rect.fromLTWH(x, 0, size.width * 0.45, size.height);
    p.shader = const LinearGradient(
      colors: [
        Color(0x00FFFFFF),
        Color(0x66FFFFFF),
        Color(0x00FFFFFF),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).createShader(rect);
    canvas.save();
    canvas.transform(Matrix4.skewX(-0.35).storage);
    canvas.drawRect(rect, p);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ShinePainter oldDelegate) => oldDelegate.t != t;
}
