import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_3d/routes/app_routes.dart';
import '../providers/weather_provider.dart';
import '../widgets/animated_background.dart';
import '../utils/weather_utils.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _rotate;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400));
    _scale = CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.7, curve: Curves.elasticOut));
    _rotate = CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.8, curve: Curves.easeOutCubic));
    _fade = CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1, curve: Curves.easeIn));
    _controller.forward();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final provider = context.read<WeatherProvider>();
    // Kick off loading while the splash animation plays.
    final initFuture = provider.init();
    await Future.wait([
      initFuture,
      Future.delayed(const Duration(milliseconds: 1800)),
    ]);
    if (!mounted) return;
    Navigator.of(context).popAndPushNamed(
      AppRoutes.home,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      mood: SkyMood.clearDay,
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Opacity(
              opacity: _fade.value,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.002)
                  ..rotateY((1 - _rotate.value) * 1.2)
                  ..scale(_scale.value),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          colors: [Color(0xFFFFE082), Color(0xFFFFA000)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.5),
                            blurRadius: 40,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.wb_sunny_rounded,
                          size: 64, color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'SkyCast 3D',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Weather, beautifully rendered.',
                      style: TextStyle(
                          fontSize: 14, color: Colors.white.withOpacity(0.75)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
