import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/weather_utils.dart';

/// A living, breathing background: a slowly-shifting gradient (per weather
/// mood) with several soft, blurred "orbs" that drift and pulse to create
/// a sense of depth (a cheap but very effective pseudo-3D parallax look
/// without needing any external image/animation assets).
class AnimatedBackground extends StatefulWidget {
  final SkyMood mood;
  final Widget child;

  const AnimatedBackground({super.key, required this.mood, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late final AnimationController _slowController;
  late final AnimationController _mediumController;

  @override
  void initState() {
    super.initState();
    _slowController = AnimationController(vsync: this, duration: const Duration(seconds: 18))
      ..repeat();
    _mediumController = AnimationController(vsync: this, duration: const Duration(seconds: 9))
      ..repeat();
  }

  @override
  void dispose() {
    _slowController.dispose();
    _mediumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = WeatherUtils.gradientFor(widget.mood);
    final accent = WeatherUtils.accentFor(widget.mood);

    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 900),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _slowController,
          builder: (context, _) {
            final t = _slowController.value * 2 * pi;
            return Positioned(
              top: 80 + sin(t) * 40,
              left: -60 + cos(t) * 30,
              child: _blurOrb(220, accent.withOpacity(0.25)),
            );
          },
        ),
        AnimatedBuilder(
          animation: _mediumController,
          builder: (context, _) {
            final t = _mediumController.value * 2 * pi;
            return Positioned(
              bottom: 40 + cos(t) * 50,
              right: -40 + sin(t) * 40,
              child: _blurOrb(260, Colors.white.withOpacity(0.10)),
            );
          },
        ),
        AnimatedBuilder(
          animation: _slowController,
          builder: (context, _) {
            final t = (_slowController.value + 0.5) * 2 * pi;
            return Positioned(
              top: 260 + sin(t) * 30,
              right: 20 + cos(t) * 60,
              child: _blurOrb(150, Colors.white.withOpacity(0.08)),
            );
          },
        ),
        // Subtle vignette so foreground glass cards pop with contrast
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topCenter,
              radius: 1.4,
              colors: [Colors.transparent, Colors.black.withOpacity(0.28)],
            ),
          ),
        ),
        widget.child,
      ],
    );
  }

  Widget _blurOrb(double size, Color color) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withOpacity(0)],
          ),
        ),
      ),
    );
  }
}
