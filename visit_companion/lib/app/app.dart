import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/router/app_router.dart';
import '../core/services/app_services.dart';
import '../core/theme/app_theme.dart';
import '../features/emergency/presentation/emergency_view_model.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/presentation/auth_view_model.dart';
import '../features/finder/presentation/finder_view_model.dart';
import '../features/finder/data/facility_repository.dart';
import '../features/home/presentation/home_view_model.dart';
import '../features/me/presentation/me_view_model.dart';
import '../features/onboarding/data/onboarding_repository.dart';
import '../features/onboarding/presentation/onboarding_view_model.dart';
import '../features/profiles/data/profile_repository.dart';
import '../features/profiles/presentation/profile_view_model.dart';
import '../features/privacy/data/privacy_repository.dart';
import '../features/privacy/presentation/privacy_view_model.dart';
import '../features/reminders/data/reminder_repository.dart';
import '../features/reminders/presentation/reminder_view_model.dart';
import '../features/subscription/data/subscription_repository.dart';
import '../features/subscription/presentation/subscription_view_model.dart';
import '../features/vault/presentation/vault_view_model.dart';
import '../features/vault/data/document_repository.dart';
import '../features/visits/presentation/visits_view_model.dart';
import '../features/visits/data/visit_repository.dart';

class VisitCompanionApp extends StatelessWidget {
  const VisitCompanionApp({super.key, this.services});

  final AppServices? services;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppServices>.value(value: services ?? AppServices.local()),
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(InMemoryAuthRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => OnboardingViewModel(InMemoryOnboardingRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileViewModel(InMemoryProfileRepository()),
        ),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(
          create: (_) => FinderViewModel(InMemoryFacilityRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => VisitsViewModel(InMemoryVisitRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => VaultViewModel(InMemoryDocumentRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => ReminderViewModel(InMemoryReminderRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              SubscriptionViewModel(InMemorySubscriptionRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => PrivacyViewModel(InMemoryPrivacyRepository()),
        ),
        ChangeNotifierProvider(create: (_) => MeViewModel()),
        ChangeNotifierProvider(create: (_) => EmergencyViewModel()),
      ],
      child: MaterialApp.router(
        title: 'Visit Companion',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.light,
        locale: const Locale('en'),
        supportedLocales: const [Locale('en'), Locale('ur')],
        routerConfig: AppRouter.router,
      ),
    );
  }
}
