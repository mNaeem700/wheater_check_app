abstract interface class NotificationService {
  Future<void> initialize();

  Future<void> schedule({
    required String id,
    required String title,
    required String body,
    required DateTime scheduledAt,
  });

  Future<void> cancel(String id);
}

class NoOpNotificationService implements NotificationService {
  final Map<String, DateTime> scheduled = {};

  @override
  Future<void> initialize() async {}

  @override
  Future<void> schedule({
    required String id,
    required String title,
    required String body,
    required DateTime scheduledAt,
  }) async {
    scheduled[id] = scheduledAt;
  }

  @override
  Future<void> cancel(String id) async {
    scheduled.remove(id);
  }
}
