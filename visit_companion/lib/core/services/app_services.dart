import 'analytics_service.dart';
import 'crash_reporting_service.dart';
import 'notification_service.dart';
import 'remote_config_service.dart';

class AppServices {
  const AppServices({
    required this.analytics,
    required this.crashReporting,
    required this.notifications,
    required this.remoteConfig,
  });

  factory AppServices.local() {
    return AppServices(
      analytics: NoOpAnalyticsService(),
      crashReporting: NoOpCrashReportingService(),
      notifications: NoOpNotificationService(),
      remoteConfig: NoOpRemoteConfigService(),
    );
  }

  final AnalyticsService analytics;
  final CrashReportingService crashReporting;
  final NotificationService notifications;
  final RemoteConfigService remoteConfig;

  Future<void> initialize() async {
    await notifications.initialize();
    await remoteConfig.initialize();
  }
}
