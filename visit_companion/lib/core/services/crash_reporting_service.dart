abstract interface class CrashReportingService {
  Future<void> setEnabled(bool enabled);

  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
  });
}

class NoOpCrashReportingService implements CrashReportingService {
  bool _enabled = false;

  bool get enabled => _enabled;

  @override
  Future<void> setEnabled(bool enabled) async {
    _enabled = enabled;
  }

  @override
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
  }) async {
    if (!_enabled) return;
  }
}
