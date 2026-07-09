import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';

enum LoadStatus { initial, loading, success, error }

/// The single source of truth for weather state in the app.
/// Screens listen to this via [Provider]/[Consumer] and call its methods
/// to load weather by city name, by coordinates, or by device GPS location.
class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();

  LoadStatus status = LoadStatus.initial;
  String? errorMessage;

  CurrentWeather? current;
  ForecastData? forecast;

  bool useCelsius = true;
  List<String> recentSearches = [];

  static const _prefsUnitKey = 'use_celsius';
  static const _prefsRecentKey = 'recent_searches';
  static const _prefsLastCityKey = 'last_city';

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    useCelsius = prefs.getBool(_prefsUnitKey) ?? true;
    recentSearches = prefs.getStringList(_prefsRecentKey) ?? [];
    final lastCity = prefs.getString(_prefsLastCityKey);

    if (lastCity != null && lastCity.isNotEmpty) {
      await loadByCity(lastCity);
    } else {
      await loadByCurrentLocation();
    }
  }

  String get unitsParam => useCelsius ? 'metric' : 'imperial';
  String get unitSymbol => useCelsius ? '°C' : '°F';

  Future<void> toggleUnits() async {
    useCelsius = !useCelsius;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsUnitKey, useCelsius);
    if (current != null) {
      await loadByCity(current!.city, silent: true);
    }
  }

  Future<void> loadByCity(String city, {bool silent = false}) async {
    if (!silent) {
      status = LoadStatus.loading;
      errorMessage = null;
      notifyListeners();
    }
    try {
      final results = await Future.wait([
        _weatherService.getCurrentByCity(city, units: unitsParam),
        _weatherService.getForecastByCity(city, units: unitsParam),
      ]);
      current = results[0] as CurrentWeather;
      forecast = results[1] as ForecastData;
      status = LoadStatus.success;
      await _rememberCity(city);
    } catch (e) {
      status = LoadStatus.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> loadByCoords(double lat, double lon) async {
    status = LoadStatus.loading;
    errorMessage = null;
    notifyListeners();
    try {
      final results = await Future.wait([
        _weatherService.getCurrentByCoords(lat, lon, units: unitsParam),
        _weatherService.getForecastByCoords(lat, lon, units: unitsParam),
      ]);
      current = results[0] as CurrentWeather;
      forecast = results[1] as ForecastData;
      status = LoadStatus.success;
      if (current != null) await _rememberCity(current!.city);
    } catch (e) {
      status = LoadStatus.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> loadByCurrentLocation() async {
    status = LoadStatus.loading;
    errorMessage = null;
    notifyListeners();
    try {
      final pos = await _locationService.getCurrentPosition();
      await loadByCoords(pos.latitude, pos.longitude);
    } catch (e) {
      status = LoadStatus.error;
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<List<CitySearchResult>> searchCities(String query) {
    return _weatherService.searchCities(query);
  }

  Future<void> _rememberCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsLastCityKey, city);
    recentSearches.removeWhere((c) => c.toLowerCase() == city.toLowerCase());
    recentSearches.insert(0, city);
    if (recentSearches.length > 6) {
      recentSearches = recentSearches.sublist(0, 6);
    }
    await prefs.setStringList(_prefsRecentKey, recentSearches);
  }

  Future<void> clearRecentSearches() async {
    recentSearches = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsRecentKey, []);
    notifyListeners();
  }
}
