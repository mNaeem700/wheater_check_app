abstract interface class AnalyticsService {
  Future<void> setEnabled(bool enabled);

  Future<void> logEvent(
    String name, {
    Map<String, Object?> parameters = const {},
  });
}

class NoOpAnalyticsService implements AnalyticsService {
  bool _enabled = false;

  bool get enabled => _enabled;

  @override
  Future<void> setEnabled(bool enabled) async {
    _enabled = enabled;
  }

  @override
  Future<void> logEvent(
    String name, {
    Map<String, Object?> parameters = const {},
  }) async {
    if (!_enabled) return;
  }
}
