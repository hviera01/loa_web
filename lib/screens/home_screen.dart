import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/gradient_backdrop.dart';
import '../widgets/heart_field.dart';
import '../widgets/love_card.dart';
import '../widgets/shine_button.dart';
import '../widgets/typewriter.dart';
import 'story_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double> _scale;

  late final AnimationController _float;
  late final Animation<double> _floatY;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.98, end: 1.02).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));

    _float = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200))..repeat(reverse: true);
    _floatY = Tween<double>(begin: 0.0, end: -10.0).animate(CurvedAnimation(parent: _float, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulse.dispose();
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isWide = w >= 900;

    return Scaffold(
      body: Stack(
        children: [
          const GradientBackdrop(),
          HeartField(seed: 7, density: isWide ? 1.1 : 1.0),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isWide ? 28 : 18, vertical: 18),
                  child: isWide ? _wideLayout(context) : _mobileLayout(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _wideLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ScaleTransition(
            scale: _scale,
            child: _leftPane(context, big: true),
          ),
        ),
        const SizedBox(width: 18),
        Expanded(child: _rightPane(context)),
      ],
    );
  }

  Widget _mobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        children: [
          ScaleTransition(scale: _scale, child: _leftPane(context, big: false)),
          const SizedBox(height: 14),
          _rightPane(context),
        ],
      ),
    );
  }

  Widget _leftPane(BuildContext context, {required bool big}) {
    final titleStyle = Theme.of(context).textTheme.displaySmall?.copyWith(
          fontWeight: FontWeight.w800,
          height: 1.02,
          letterSpacing: -0.5,
        );

    final subStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.white.withOpacity(0.86),
          height: 1.35,
        );

    return LoveCard(
      padding: EdgeInsets.all(big ? 24 : 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              _glowPill('Hecho con amor'),
              _glowPill('Para ti 💖'),
            ],
          ),
          const SizedBox(height: 16),
          Text('Mi persona favorita\nse merece algo\nincreíble ✨', style: titleStyle),
          const SizedBox(height: 14),
          Typewriter(
            lines: const [
              'Hoy quería recordarte algo simple:',
              'me haces feliz, me das paz,',
              'y te elijo una y mil veces.',
            ],
            style: subStyle,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: ShineButton(
                  text: 'Abrir sorpresa',
                  icon: Icons.favorite,
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 650),
                        pageBuilder: (_, a, __) => FadeTransition(opacity: a, child: const StoryScreen()),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              _miniButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rightPane(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _floatY,
            builder: (_, child) => Transform.translate(offset: Offset(0, _floatY.value), child: child),
            child: LoveCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nuestras fotos ✨', style: t.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 12),
                  _photoRow(context),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          LoveCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pequeñas cosas que siento por ti', style: t.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 14),
                _smallCard(context, 'Un detalle', 'Porque lo nuestro no se explica, se siente.', Icons.auto_awesome),
                const SizedBox(height: 12),
                _smallCard(context, 'Un abrazo', 'De esos que curan, de los que se quedan.', Icons.volunteer_activism),
                const SizedBox(height: 12),
                _smallCard(context, 'Una promesa', 'Cuidarte, apoyarte, y hacerte reír siempre.', Icons.favorite_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _photoRow(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isWide = w >= 900;

    if (isWide) {
      return Row(
        children: [
          Expanded(child: _photoTile('assets/photos/1.jpg', delayMs: 0)),
          const SizedBox(width: 12),
          Expanded(child: _photoTile('assets/photos/2.jpg', delayMs: 140)),
        ],
      );
    }

    return Column(
      children: [
        _photoTile('assets/photos/1.jpg', delayMs: 0),
        const SizedBox(height: 12),
        _photoTile('assets/photos/2.jpg', delayMs: 140),
      ],
    );
  }

  Widget _photoTile(String asset, {required int delayMs}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 720 + delayMs),
      curve: Curves.easeOutCubic,
      builder: (context, v, child) {
        final s = 0.96 + 0.04 * v;
        return Opacity(opacity: v, child: Transform.scale(scale: s, child: child));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
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
                      Colors.black.withOpacity(0.00),
                      Colors.black.withOpacity(0.40),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              bottom: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: Colors.black.withOpacity(0.30),
                  border: Border.all(color: Colors.white.withOpacity(0.14)),
                ),
                child: Text('💞', style: TextStyle(color: Colors.white.withOpacity(0.92), fontWeight: FontWeight.w900)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallCard(BuildContext context, String title, String body, IconData icon) {
    final t = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.10)),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                colors: [Color(0xFFFF4D8D), Color(0xFFFFC2D4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(color: const Color(0xFFFF4D8D).withOpacity(0.35), blurRadius: 18, offset: const Offset(0, 10)),
              ],
            ),
            child: Icon(icon, color: Colors.black.withOpacity(0.85)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: t.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(body, style: t.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.85), height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _glowPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withOpacity(0.06),
        border: Border.all(color: Colors.white.withOpacity(0.10)),
        boxShadow: [
          BoxShadow(color: const Color(0xFFFF4D8D).withOpacity(0.14), blurRadius: 18, offset: const Offset(0, 10)),
        ],
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
    );
  }

  Widget _miniButton(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => _showNote(context),
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
          color: Colors.white.withOpacity(0.06),
        ),
        child: const Icon(Icons.message_rounded),
      ),
    );
  }

  void _showNote(BuildContext context) {
    final notes = [
      'Si te abrazo, el mundo se calma.',
      'Gracias por existir.',
      'Eres mi lugar seguro.',
      'Lo más bonito: tú.',
      'Te elijo hoy también.',
    ];
    final pick = notes[Random().nextInt(notes.length)];

    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: LoveCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.favorite, size: 42, color: Color(0xFFFF4D8D)),
                const SizedBox(height: 12),
                Text(pick, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ShineButton(
                    text: 'Cerrar',
                    icon: Icons.close,
                    onTap: () => Navigator.pop(context),
                    compact: true,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
