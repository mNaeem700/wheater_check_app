import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/weather_model.dart';
import '../utils/weather_utils.dart';
import 'glass_container.dart';

class HourlyForecastList extends StatelessWidget {
  final List<HourlyForecast> hourly;
  final String unitSymbol;

  const HourlyForecastList({super.key, required this.hourly, required this.unitSymbol});

  @override
  Widget build(BuildContext context) {
    if (hourly.isEmpty) return const SizedBox.shrink();

    return GlassContainer(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: SizedBox(
        height: 110,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: hourly.length,
          itemBuilder: (context, index) {
            final h = hourly[index];
            final mood = WeatherUtils.moodFor(h.condition, isDay: true);
            return Container(
              width: 70,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    WeatherUtils.formatHour(h.dt),
                    style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.75)),
                  ),
                  const SizedBox(height: 10),
                  Icon(WeatherUtils.iconFor(mood), color: WeatherUtils.accentFor(mood), size: 26),
                  const SizedBox(height: 10),
                  Text(
                    '${h.tempC.round()}°',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: (index * 60).ms, duration: 350.ms).slideY(begin: 0.3, end: 0);
          },
        ),
      ),
    );
  }
}
