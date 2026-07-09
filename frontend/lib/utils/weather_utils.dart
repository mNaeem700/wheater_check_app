import 'package:flutter/material.dart';

/// Central place that maps a weather "condition" string (Clear, Rain, Clouds,
/// Snow, Thunderstorm, Drizzle, Mist/Fog...) plus day/night to:
///  - a gradient used for the animated background
///  - an accent color used across cards/buttons
///  - a Material icon used as a fallback / for lists
enum SkyMood { clearDay, clearNight, cloudyDay, cloudyNight, rain, thunderstorm, snow, mist }

class WeatherUtils {
  static SkyMood moodFor(String condition, {required bool isDay}) {
    final c = condition.toLowerCase();
    if (c.contains('thunder')) return SkyMood.thunderstorm;
    if (c.contains('snow')) return SkyMood.snow;
    if (c.contains('rain') || c.contains('drizzle')) return SkyMood.rain;
    if (c.contains('mist') || c.contains('fog') || c.contains('haze') || c.contains('smoke')) {
      return SkyMood.mist;
    }
    if (c.contains('cloud')) return isDay ? SkyMood.cloudyDay : SkyMood.cloudyNight;
    return isDay ? SkyMood.clearDay : SkyMood.clearNight;
  }

  static List<Color> gradientFor(SkyMood mood) {
    switch (mood) {
      case SkyMood.clearDay:
        return const [Color(0xFF4FACFE), Color(0xFF00F2FE)];
      case SkyMood.clearNight:
        return const [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)];
      case SkyMood.cloudyDay:
        return const [Color(0xFF757F9A), Color(0xFFD7DDE8)];
      case SkyMood.cloudyNight:
        return const [Color(0xFF232526), Color(0xFF414345)];
      case SkyMood.rain:
        return const [Color(0xFF3A6073), Color(0xFF16222A)];
      case SkyMood.thunderstorm:
        return const [Color(0xFF232526), Color(0xFF0F2027)];
      case SkyMood.snow:
        return const [Color(0xFFE6DADA), Color(0xFF274046)];
      case SkyMood.mist:
        return const [Color(0xFFBDC3C7), Color(0xFF2C3E50)];
    }
  }

  static Color accentFor(SkyMood mood) {
    switch (mood) {
      case SkyMood.clearDay:
        return const Color(0xFFFFD54F);
      case SkyMood.clearNight:
        return const Color(0xFF90CAF9);
      case SkyMood.cloudyDay:
        return const Color(0xFFECEFF1);
      case SkyMood.cloudyNight:
        return const Color(0xFFB0BEC5);
      case SkyMood.rain:
        return const Color(0xFF4FC3F7);
      case SkyMood.thunderstorm:
        return const Color(0xFFFFD740);
      case SkyMood.snow:
        return const Color(0xFFE1F5FE);
      case SkyMood.mist:
        return const Color(0xFFCFD8DC);
    }
  }

  static IconData iconFor(SkyMood mood) {
    switch (mood) {
      case SkyMood.clearDay:
        return Icons.wb_sunny_rounded;
      case SkyMood.clearNight:
        return Icons.nightlight_round;
      case SkyMood.cloudyDay:
      case SkyMood.cloudyNight:
        return Icons.cloud_rounded;
      case SkyMood.rain:
        return Icons.grain_rounded;
      case SkyMood.thunderstorm:
        return Icons.flash_on_rounded;
      case SkyMood.snow:
        return Icons.ac_unit_rounded;
      case SkyMood.mist:
        return Icons.blur_on_rounded;
    }
  }

  static bool isDayTime(int dt, int sunrise, int sunset) {
    if (sunrise == 0 || sunset == 0) {
      final hour = DateTime.fromMillisecondsSinceEpoch(dt * 1000).hour;
      return hour >= 6 && hour < 18;
    }
    return dt >= sunrise && dt < sunset;
  }

  static String formatHour(int dt) {
    final date = DateTime.fromMillisecondsSinceEpoch(dt * 1000);
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final suffix = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour$suffix';
  }

  static String formatWeekday(String yyyyMmDd) {
    final date = DateTime.parse(yyyyMmDd);
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }
}
