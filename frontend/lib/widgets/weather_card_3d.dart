import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/weather_utils.dart';
import 'glass_container.dart';
import 'weather_icon_3d.dart';

/// The hero card showing current temperature/condition. Drag your finger
/// across it and it tilts in real 3D (perspective Matrix4 transform) like a
/// physical glass card catching the light — snaps back smoothly on release.
class WeatherCard3D extends StatefulWidget {
  final CurrentWeather weather;
  final SkyMood mood;
  final String unitSymbol;

  const WeatherCard3D({
    super.key,
    required this.weather,
    required this.mood,
    required this.unitSymbol,
  });

  @override
  State<WeatherCard3D> createState() => _WeatherCard3DState();
}

class _WeatherCard3DState extends State<WeatherCard3D>
    with SingleTickerProviderStateMixin {
  double _rotX = 0;
  double _rotY = 0;
  late final AnimationController _resetController;

  @override
  void initState() {
    super.initState();
    _resetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _resetController.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details, Size size) {
    setState(() {
      _rotY = ((details.localPosition.dx / size.width) - 0.5) * 0.6;
      _rotX = -((details.localPosition.dy / size.height) - 0.5) * 0.6;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _rotX = 0;
      _rotY = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.weather;
    final accent = WeatherUtils.accentFor(widget.mood);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight == double.infinity
            ? 380
            : constraints.maxHeight);
        return GestureDetector(
          onPanUpdate: (d) => _onPanUpdate(d, size),
          onPanEnd: _onPanEnd,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOut,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0015)
              ..rotateX(_rotX)
              ..rotateY(_rotY),
            transformAlignment: Alignment.center,
            child: GlassContainer(
              borderRadius: 32,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              w.city,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (w.country != null)
                              Text(
                                w.country!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                          ],
                        ),
                      ),
                      WeatherIcon3D(mood: widget.mood, size: 84),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${w.tempC.round()}${widget.unitSymbol}',
                    style: const TextStyle(
                      fontSize: 74,
                      fontWeight: FontWeight.w200,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    w.description[0].toUpperCase() + w.description.substring(1),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.85),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Feels like ${w.feelsLikeC.round()}${widget.unitSymbol} · H:${w.tempMaxC.round()}° L:${w.tempMinC.round()}°',
                    style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.65)),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatChip(icon: Icons.air_rounded, label: '${w.windSpeed.toStringAsFixed(1)} m/s', accent: accent),
                      _StatChip(icon: Icons.water_drop_rounded, label: '${w.humidity}%', accent: accent),
                      _StatChip(icon: Icons.speed_rounded, label: '${w.pressure} hPa', accent: accent),
                      _StatChip(icon: Icons.visibility_rounded, label: '${(w.visibility / 1000).toStringAsFixed(1)} km', accent: accent),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accent;

  const _StatChip({required this.icon, required this.label, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: accent, size: 20),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
