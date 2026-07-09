import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/weather_utils.dart';

/// Renders the main weather icon with a genuine 3D feel:
///  - a continuous Y-axis rotation using a Matrix4 perspective transform
///    (this is what makes it look like it's spinning "into" the screen
///    rather than just scaling, which is the classic 3D-card trick)
///  - a soft pulsing glow behind it
///  - a layered drop shadow that moves opposite the rotation for parallax
class WeatherIcon3D extends StatefulWidget {
  final SkyMood mood;
  final double size;

  const WeatherIcon3D({super.key, required this.mood, this.size = 140});

  @override
  State<WeatherIcon3D> createState() => _WeatherIcon3DState();
}

class _WeatherIcon3DState extends State<WeatherIcon3D> with TickerProviderStateMixin {
  late final AnimationController _rotationController;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(vsync: this, duration: const Duration(seconds: 10))
      ..repeat();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = WeatherUtils.accentFor(widget.mood);
    final icon = WeatherUtils.iconFor(widget.mood);

    return AnimatedBuilder(
      animation: Listenable.merge([_rotationController, _pulseController]),
      builder: (context, _) {
        // Oscillate between -0.35 and 0.35 radians for a believable "sway"
        // rather than a full spin, which reads as more natural for a sky icon.
        final angle = sin(_rotationController.value * 2 * pi) * 0.35;
        final pulse = 0.9 + _pulseController.value * 0.15;

        return SizedBox(
          width: widget.size * 1.6,
          height: widget.size * 1.6,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Pulsing glow
              Transform.scale(
                scale: pulse,
                child: Container(
                  width: widget.size * 1.3,
                  height: widget.size * 1.3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [accent.withOpacity(0.45), accent.withOpacity(0)],
                    ),
                  ),
                ),
              ),
              // Drop shadow, offset opposite the tilt for a parallax feel
              Transform.translate(
                offset: Offset(-angle * 40, 14),
                child: Container(
                  width: widget.size * 0.7,
                  height: widget.size * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.black.withOpacity(0.18),
                  ),
                ),
              ),
              // The icon itself, perspective-transformed
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0025) // perspective depth
                  ..rotateY(angle)
                  ..rotateX(angle * 0.4),
                child: Icon(
                  icon,
                  size: widget.size,
                  color: accent,
                  shadows: [
                    Shadow(color: accent.withOpacity(0.8), blurRadius: 30),
                    const Shadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 6)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
