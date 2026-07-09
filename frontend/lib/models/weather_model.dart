/// Data models for the Weather App.
/// These map 1:1 onto the JSON shape returned by our Node/Express backend
/// (see backend/server.js -> normalizeCurrent / normalizeForecast).

class CurrentWeather {
  final String city;
  final String? country;
  final double lat;
  final double lon;
  final double tempC;
  final double feelsLikeC;
  final double tempMinC;
  final double tempMaxC;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final int windDeg;
  final int clouds;
  final int visibility;
  final int sunrise;
  final int sunset;
  final int timezone;
  final int dt;
  final String condition; // e.g. "Clear", "Rain", "Clouds"
  final String description;
  final String icon; // OpenWeatherMap icon code, e.g. "01d"

  CurrentWeather({
    required this.city,
    this.country,
    required this.lat,
    required this.lon,
    required this.tempC,
    required this.feelsLikeC,
    required this.tempMinC,
    required this.tempMaxC,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.windDeg,
    required this.clouds,
    required this.visibility,
    required this.sunrise,
    required this.sunset,
    required this.timezone,
    required this.dt,
    required this.condition,
    required this.description,
    required this.icon,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      city: json['city'] ?? 'Unknown',
      country: json['country'],
      lat: (json['coord']?['lat'] ?? 0).toDouble(),
      lon: (json['coord']?['lon'] ?? 0).toDouble(),
      tempC: (json['tempC'] ?? 0).toDouble(),
      feelsLikeC: (json['feelsLikeC'] ?? 0).toDouble(),
      tempMinC: (json['tempMinC'] ?? 0).toDouble(),
      tempMaxC: (json['tempMaxC'] ?? 0).toDouble(),
      humidity: (json['humidity'] ?? 0).toInt(),
      pressure: (json['pressure'] ?? 0).toInt(),
      windSpeed: (json['windSpeed'] ?? 0).toDouble(),
      windDeg: (json['windDeg'] ?? 0).toInt(),
      clouds: (json['clouds'] ?? 0).toInt(),
      visibility: (json['visibility'] ?? 0).toInt(),
      sunrise: (json['sunrise'] ?? 0).toInt(),
      sunset: (json['sunset'] ?? 0).toInt(),
      timezone: (json['timezone'] ?? 0).toInt(),
      dt: (json['dt'] ?? 0).toInt(),
      condition: json['condition'] ?? 'Clear',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '01d',
    );
  }
}

class HourlyForecast {
  final int dt;
  final double tempC;
  final String condition;
  final String icon;
  final double pop;

  HourlyForecast({
    required this.dt,
    required this.tempC,
    required this.condition,
    required this.icon,
    required this.pop,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      dt: (json['dt'] ?? 0).toInt(),
      tempC: (json['tempC'] ?? 0).toDouble(),
      condition: json['condition'] ?? 'Clear',
      icon: json['icon'] ?? '01d',
      pop: (json['pop'] ?? 0).toDouble(),
    );
  }
}

class DailyForecast {
  final String date;
  final double tempMinC;
  final double tempMaxC;
  final String icon;
  final String condition;

  DailyForecast({
    required this.date,
    required this.tempMinC,
    required this.tempMaxC,
    required this.icon,
    required this.condition,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: json['date'] ?? '',
      tempMinC: (json['tempMinC'] ?? 0).toDouble(),
      tempMaxC: (json['tempMaxC'] ?? 0).toDouble(),
      icon: json['icon'] ?? '01d',
      condition: json['condition'] ?? 'Clear',
    );
  }
}

class ForecastData {
  final String city;
  final String? country;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;

  ForecastData({
    required this.city,
    this.country,
    required this.hourly,
    required this.daily,
  });

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    return ForecastData(
      city: json['city'] ?? 'Unknown',
      country: json['country'],
      hourly: (json['hourly'] as List? ?? [])
          .map((e) => HourlyForecast.fromJson(e))
          .toList(),
      daily: (json['daily'] as List? ?? [])
          .map((e) => DailyForecast.fromJson(e))
          .toList(),
    );
  }
}

class CitySearchResult {
  final String name;
  final String? state;
  final String? country;
  final double lat;
  final double lon;

  CitySearchResult({
    required this.name,
    this.state,
    this.country,
    required this.lat,
    required this.lon,
  });

  factory CitySearchResult.fromJson(Map<String, dynamic> json) {
    return CitySearchResult(
      name: json['name'] ?? '',
      state: json['state'],
      country: json['country'],
      lat: (json['lat'] ?? 0).toDouble(),
      lon: (json['lon'] ?? 0).toDouble(),
    );
  }

  String get displayName {
    final parts = [
      name,
      if (state != null && state!.isNotEmpty) state,
      country,
    ].whereType<String>().toList();
    return parts.join(', ');
  }
}
