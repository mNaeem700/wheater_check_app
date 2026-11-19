abstract interface class RemoteConfigService {
  Future<void> initialize();

  String getString(String key, {String fallback = ''});

  bool getBool(String key, {bool fallback = false});
}

class NoOpRemoteConfigService implements RemoteConfigService {
  final Map<String, Object> values = {};

  @override
  Future<void> initialize() async {}

  @override
  String getString(String key, {String fallback = ''}) {
    final value = values[key];
    return value is String ? value : fallback;
  }

  @override
  bool getBool(String key, {bool fallback = false}) {
    final value = values[key];
    return value is bool ? value : fallback;
  }
}
