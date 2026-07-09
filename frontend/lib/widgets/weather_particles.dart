import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/weather_utils.dart';

/// A lightweight particle system drawn with CustomPainter. Depending on the
/// current [SkyMood] it renders falling rain streaks, drifting snowflakes,
/// or softly floating cloud puffs — purely with vector drawing, so there
/// are zero external asset dependencies (works offline, out of the box).
class WeatherParticles extends StatefulWidget {
  final SkyMood mood;
  const WeatherParticles({super.key, required this.mood});

  @override
  State<WeatherParticles> createState() => _WeatherParticlesState();
}

class _WeatherParticlesState extends State<WeatherParticles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _rng = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 60))
      ..addListener(_tick)
      ..repeat();
    _seedParticles();
  }

  void _seedParticles() {
    _particles.clear();
    final count = switch (widget.mood) {
      SkyMood.rain => 90,
      SkyMood.thunderstorm => 110,
      SkyMood.snow => 70,
      SkyMood.cloudyDay || SkyMood.cloudyNight => 6,
      SkyMood.mist => 5,
      _ => 0,
    };
    for (int i = 0; i < count; i++) {
      _particles.add(_Particle.random(_rng, widget.mood));
    }
  }

  @override
  void didUpdateWidget(covariant WeatherParticles oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mood != widget.mood) _seedParticles();
  }

  void _tick() {
    for (final p in _particles) {
      p.advance(widget.mood);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_particles.isEmpty) return const SizedBox.shrink();
    return IgnorePointer(
      child: CustomPaint(
        painter: _ParticlePainter(_particles, widget.mood),
        size: Size.infinite,
      ),
    );
  }
}

class _Particle {
  double x, y, speed, size, drift, opacity;
  _Particle(this.x, this.y, this.speed, this.size, this.drift, this.opacity);

  factory _Particle.random(Random rng, SkyMood mood) {
    return _Particle(
      rng.nextDouble(),
      rng.nextDouble(),
      0.002 + rng.nextDouble() * 0.006,
      mood == SkyMood.snow ? 2 + rng.nextDouble() * 3 : 1 + rng.nextDouble() * 2,
      rng.nextDouble() * 2 - 1,
      0.3 + rng.nextDouble() * 0.5,
    );
  }

  void advance(SkyMood mood) {
    if (mood == SkyMood.rain || mood == SkyMood.thunderstorm) {
      y += speed * 6;
      x += drift * 0.0008;
    } else if (mood == SkyMood.snow) {
      y += speed * 1.4;
      x += sin(y * 20) * 0.0015;
    } else {
      x += speed * 0.6;
    }
    if (y > 1) y = -0.02;
    if (x > 1) x = -0.02;
    if (x < -0.02) x = 1;
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final SkyMood mood;
  _ParticlePainter(this.particles, this.mood);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final dx = p.x * size.width;
      final dy = p.y * size.height;

      if (mood == SkyMood.rain || mood == SkyMood.thunderstorm) {
        final paint = Paint()
          ..color = Colors.white.withOpacity(p.opacity)
          ..strokeWidth = 1.6
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(Offset(dx, dy), Offset(dx - 2, dy + 14), paint);
      } else if (mood == SkyMood.snow) {
        final paint = Paint()..color = Colors.white.withOpacity(p.opacity);
        canvas.drawCircle(Offset(dx, dy), p.size, paint);
      } else {
        final paint = Paint()..color = Colors.white.withOpacity(p.opacity * 0.4);
        canvas.drawCircle(Offset(dx, dy), p.size * 14, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
