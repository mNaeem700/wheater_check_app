import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/weather_model.dart';
import '../utils/weather_utils.dart';
import 'glass_container.dart';

class DailyForecastList extends StatelessWidget {
  final List<DailyForecast> daily;
  final String unitSymbol;

  const DailyForecastList({super.key, required this.daily, required this.unitSymbol});

  @override
  Widget build(BuildContext context) {
    if (daily.isEmpty) return const SizedBox.shrink();

    final overallMin = daily.map((d) => d.tempMinC).reduce((a, b) => a < b ? a : b);
    final overallMax = daily.map((d) => d.tempMaxC).reduce((a, b) => a > b ? a : b);
    final range = (overallMax - overallMin).clamp(1, double.infinity);

    return GlassContainer(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        children: [
          for (int i = 0; i < daily.length; i++) ...[
            _DailyRow(
              day: daily[i],
              overallMin: overallMin,
              range: range.toDouble(),
              isFirst: i == 0,
            ).animate().fadeIn(delay: (i * 80).ms, duration: 400.ms).slideX(begin: 0.1, end: 0),
            if (i != daily.length - 1)
              Divider(color: Colors.white.withOpacity(0.12), height: 20),
          ],
        ],
      ),
    );
  }
}

class _DailyRow extends StatelessWidget {
  final DailyForecast day;
  final double overallMin;
  final double range;
  final bool isFirst;

  const _DailyRow({
    required this.day,
    required this.overallMin,
    required this.range,
    required this.isFirst,
  });

  @override
  Widget build(BuildContext context) {
    final mood = WeatherUtils.moodFor(day.condition, isDay: true);
    final startFrac = ((day.tempMinC - overallMin) / range).clamp(0.0, 1.0);
    final endFrac = ((day.tempMaxC - overallMin) / range).clamp(0.0, 1.0);

    return Row(
      children: [
        SizedBox(
          width: 46,
          child: Text(
            isFirst ? 'Today' : WeatherUtils.formatWeekday(day.date),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        Icon(WeatherUtils.iconFor(mood), color: WeatherUtils.accentFor(mood), size: 22),
        const SizedBox(width: 14),
        SizedBox(
          width: 34,
          child: Text('${day.tempMinC.round()}°',
              style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.6))),
        ),
        Expanded(
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: endFrac,
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(left: 0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blueAccent.withOpacity(0.7), Colors.orangeAccent],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 34,
          child: Text('${day.tempMaxC.round()}°',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}
