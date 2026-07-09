import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

/// Handles all HTTP communication with our Node/Express backend.
///
/// IMPORTANT: update [baseUrl] to point at wherever you run backend/server.js
/// - Android emulator talking to a backend on your dev machine: http://10.0.2.2:5000
/// - iOS simulator: http://localhost:5000
/// - Physical device: http://<your-computer-LAN-ip>:5000
/// - Deployed backend: https://your-deployed-backend.com
class WeatherService {
  static const String baseUrl = 'http://10.0.2.2:5000';

  Future<CurrentWeather> getCurrentByCity(String city,
      {String units = 'metric'}) async {
    final uri = Uri.parse(
        '$baseUrl/api/weather/city/${Uri.encodeComponent(city)}?units=$units');
    final res = await http.get(uri).timeout(const Duration(seconds: 15));
    _checkStatus(res);
    return CurrentWeather.fromJson(jsonDecode(res.body));
  }

  Future<CurrentWeather> getCurrentByCoords(double lat, double lon,
      {String units = 'metric'}) async {
    final uri =
        Uri.parse('$baseUrl/api/weather/coords?lat=$lat&lon=$lon&units=$units');
    final res = await http.get(uri).timeout(const Duration(seconds: 15));
    _checkStatus(res);
    return CurrentWeather.fromJson(jsonDecode(res.body));
  }

  Future<ForecastData> getForecastByCity(String city,
      {String units = 'metric'}) async {
    final uri = Uri.parse(
        '$baseUrl/api/forecast/city/${Uri.encodeComponent(city)}?units=$units');
    final res = await http.get(uri).timeout(const Duration(seconds: 15));
    _checkStatus(res);
    return ForecastData.fromJson(jsonDecode(res.body));
  }

  Future<ForecastData> getForecastByCoords(double lat, double lon,
      {String units = 'metric'}) async {
    final uri = Uri.parse(
        '$baseUrl/api/forecast/coords?lat=$lat&lon=$lon&units=$units');
    final res = await http.get(uri).timeout(const Duration(seconds: 15));
    _checkStatus(res);
    return ForecastData.fromJson(jsonDecode(res.body));
  }

  Future<List<CitySearchResult>> searchCities(String query) async {
    if (query.trim().isEmpty) return [];
    final uri =
        Uri.parse('$baseUrl/api/search?q=${Uri.encodeComponent(query)}');
    final res = await http.get(uri).timeout(const Duration(seconds: 15));
    _checkStatus(res);
    final body = jsonDecode(res.body);
    final results = (body['results'] as List? ?? []);
    return results.map((e) => CitySearchResult.fromJson(e)).toList();
  }

  void _checkStatus(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      String message = 'Request failed (${res.statusCode})';
      try {
        final decoded = jsonDecode(res.body);
        if (decoded is Map && decoded['error'] != null) {
          message = decoded['error'];
        }
      } catch (_) {}
      throw WeatherApiException(message);
    }
  }
}

class WeatherApiException implements Exception {
  final String message;
  WeatherApiException(this.message);

  @override
  String toString() => message;
}
