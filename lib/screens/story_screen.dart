import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/gradient_backdrop.dart';
import '../widgets/heart_field.dart';
import '../widgets/love_card.dart';
import '../widgets/shine_button.dart';
import '../widgets/typewriter.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> with TickerProviderStateMixin {
  late final PageController _page;
  late final AnimationController _burst;
  bool _showBurst = false;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _page = PageController();
    _burst = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
  }

  @override
  void dispose() {
    _page.dispose();
    _burst.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isWide = w >= 900;

    return Scaffold(
      body: Stack(
        children: [
          const GradientBackdrop(alt: true),
          HeartField(seed: 23, density: isWide ? 1.25 : 1.05),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isWide ? 28 : 18, vertical: 18),
                  child: Column(
                    children: [
                      _topBar(context),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Stack(
                          children: [
                            PageView(
                              controller: _page,
                              onPageChanged: (i) => setState(() => _index = i),
                              children: [
                                _pageOne(context),
                                _pageTwo(context),
                                _pageThree(context),
                              ],
                            ),
                            if (_showBurst) _burstOverlay(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _bottomControls(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white.withOpacity(0.06),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: const Icon(Icons.arrow_back_rounded),
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Para ti 💖',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _photo(String asset) {
    return LayoutBuilder(
      builder: (context, c) {
        final maxH = c.maxHeight.isFinite ? c.maxHeight : 500.0;
        final h = maxH * 0.46;

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeOutCubic,
          builder: (context, v, child) {
            final s = 0.965 + 0.035 * v;
            return Opacity(opacity: v, child: Transform.scale(scale: s, child: child));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              height: h.clamp(220.0, 360.0),
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      asset,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.06),
                            Colors.black.withOpacity(0.46),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _pageShell(BuildContext context, String title, String asset, List<String> lines, {bool showButton = false}) {
    final t = Theme.of(context).textTheme;

    return Center(
      child: LoveCard(
        padding: const EdgeInsets.all(18),
        child: LayoutBuilder(
          builder: (context, c) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: c.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Text(title, style: t.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 12),
                      _photo(asset),
                      const SizedBox(height: 14),
                      Typewriter(
                        lines: lines,
                        style: t.titleMedium?.copyWith(color: Colors.white.withOpacity(0.88), height: 1.35),
                      ),
                      const SizedBox(height: 14),
                      if (showButton)
                        SizedBox(
                          width: double.infinity,
                          child: ShineButton(
                            text: 'Toca para explotar amor',
                            icon: Icons.burst_mode,
                            onTap: () => _triggerBurst(),
                          ),
                        ),
                      const SizedBox(height: 6),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _pageOne(BuildContext context) {
    return _pageShell(
      context,
      'Capítulo 1',
      'assets/photos/1.jpg',
      const [
        'No sé cómo explicarlo sin quedarme corto:',
        'tu forma de ser me inspira,',
        'y tu sonrisa me reinicia el día.',
      ],
    );
  }

  Widget _pageTwo(BuildContext context) {
    return _pageShell(
      context,
      'Capítulo 2',
      'assets/photos/2.jpg',
      const [
        'Te amo en lo simple:',
        'en tus planes, en tus sueños,',
        'en tus días buenos y en los difíciles.',
      ],
    );
  }

  Widget _pageThree(BuildContext context) {
    return _pageShell(
      context,
      'Capítulo 3',
      'assets/photos/3.jpg',
      const [
        'Si hoy pudiera pedir un deseo:',
        'ser tu paz, tu risa,',
        'y tu hogar favorito.',
      ],
      showButton: true,
    );
  }

  Widget _bottomControls(BuildContext context) {
    final isLast = _index == 2;

    return Row(
      children: [
        Expanded(
          child: ShineButton(
            text: 'Anterior',
            icon: Icons.chevron_left_rounded,
            compact: true,
            onTap: () {
              final p = _page.page?.round() ?? _index;
              final n = (p - 1).clamp(0, 2);
              _page.animateToPage(n, duration: const Duration(milliseconds: 420), curve: Curves.easeOutCubic);
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
            child: isLast
                ? const SizedBox(key: ValueKey('no_next'), height: 48)
                : ShineButton(
                    key: const ValueKey('next_btn'),
                    text: 'Siguiente',
                    icon: Icons.chevron_right_rounded,
                    compact: true,
                    onTap: () {
                      final p = _page.page?.round() ?? _index;
                      final n = (p + 1).clamp(0, 2);
                      _page.animateToPage(n, duration: const Duration(milliseconds: 420), curve: Curves.easeOutCubic);
                    },
                  ),
          ),
        ),
      ],
    );
  }

  void _triggerBurst() async {
    setState(() => _showBurst = true);
    _burst.forward(from: 0);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _showBurst = false);
  }

  Widget _burstOverlay() {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _burst,
        builder: (context, _) {
          final v = Curves.easeOutCubic.transform(_burst.value);
          return CustomPaint(
            painter: _BurstPainter(progress: v, seed: 99),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _BurstPainter extends CustomPainter {
  final double progress;
  final int seed;

  _BurstPainter({required this.progress, required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = Random(seed);
    final c = Offset(size.width / 2, size.height * 0.48);
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 90; i++) {
      final a = rnd.nextDouble() * pi * 2;
      final dist = (rnd.nextDouble() * 0.55 + 0.25) * min(size.width, size.height) * progress;
      final p = c + Offset(cos(a), sin(a)) * dist;
      final s = (rnd.nextDouble() * 7 + 6) * (1 - progress * 0.35);
      final alpha = (1.0 - progress).clamp(0.0, 1.0);
      final col = Color.lerp(const Color(0xFFFF4D8D), const Color(0xFFFFC2D4), rnd.nextDouble())!;
      paint.color = col.withOpacity(alpha * 0.9);
      final path = Path();
      final x = p.dx;
      final y = p.dy;
      path.moveTo(x, y + s * 0.35);
      path.cubicTo(x - s, y - s * 0.25, x - s * 0.25, y - s, x, y - s * 0.45);
      path.cubicTo(x + s * 0.25, y - s, x + s, y - s * 0.25, x, y + s * 0.35);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BurstPainter oldDelegate) => oldDelegate.progress != progress;
}
