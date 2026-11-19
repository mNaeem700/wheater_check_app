import 'package:flutter_test/flutter_test.dart';
import 'package:visit_companion/core/services/analytics_service.dart';
import 'package:visit_companion/core/services/app_services.dart';
import 'package:visit_companion/core/services/crash_reporting_service.dart';
import 'package:visit_companion/core/services/notification_service.dart';
import 'package:visit_companion/core/services/remote_config_service.dart';

void main() {
  test(
    'local app services initialize without Firebase configuration',
    () async {
      final services = AppServices.local();

      await services.initialize();

      expect(services.analytics, isA<NoOpAnalyticsService>());
      expect(services.crashReporting, isA<NoOpCrashReportingService>());
      expect(services.notifications, isA<NoOpNotificationService>());
      expect(services.remoteConfig, isA<NoOpRemoteConfigService>());
    },
  );

  test('analytics only records events after consent', () async {
    final analytics = NoOpAnalyticsService();

    await analytics.logEvent('visit_started');
    expect(analytics.enabled, isFalse);

    await analytics.setEnabled(true);
    await analytics.logEvent('visit_started');
    expect(analytics.enabled, isTrue);
  });

  test('notification schedule can be cancelled', () async {
    final notifications = NoOpNotificationService();

    await notifications.schedule(
      id: 'reminder-1',
      title: 'Follow-up',
      body: 'Review your appointment',
      scheduledAt: DateTime.now().add(const Duration(hours: 1)),
    );
    expect(notifications.scheduled, contains('reminder-1'));

    await notifications.cancel('reminder-1');
    expect(notifications.scheduled, isNot(contains('reminder-1')));
  });

  test('remote config returns safe fallbacks', () {
    final config = NoOpRemoteConfigService();

    expect(config.getString('missing'), isEmpty);
    expect(config.getBool('missing'), isFalse);

    config.values['paywall_enabled'] = true;
    expect(config.getBool('paywall_enabled'), isTrue);
  });
}
