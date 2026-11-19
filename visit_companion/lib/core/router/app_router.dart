import 'package:go_router/go_router.dart';

import '../../features/emergency/presentation/emergency_page.dart';
import '../../features/emergency/presentation/emergency_card_page.dart';
import '../../features/auth/presentation/auth_page.dart';
import '../../features/finder/presentation/finder_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/me/presentation/me_page.dart';
import '../../features/onboarding/presentation/onboarding_page.dart';
import '../../features/profiles/presentation/profiles_page.dart';
import '../../features/privacy/presentation/privacy_page.dart';
import '../../features/reminders/presentation/reminders_page.dart';
import '../../features/subscription/presentation/subscription_page.dart';
import '../../features/vault/presentation/vault_page.dart';
import '../../features/visits/presentation/visits_page.dart';
import '../../features/visits/presentation/visit_summary_page.dart';
import '../../features/visits/domain/visit_model.dart';
import '../../shared/presentation/app_shell.dart';

class AppRouter {
  const AppRouter._();

  static final router = GoRouter(
    initialLocation: '/auth',
    routes: [
      GoRoute(path: '/auth', builder: (context, state) => const AuthPage()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/finder',
                builder: (context, state) => const FinderPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/visits',
                builder: (context, state) => const VisitsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/vault',
                builder: (context, state) => const VaultPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/me', builder: (context, state) => const MePage()),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/emergency',
        builder: (context, state) => const EmergencyPage(),
      ),
      GoRoute(
        path: '/visit-summary',
        builder: (context, state) {
          final visit = state.extra! as VisitModel;
          return VisitSummaryPage(visit: visit);
        },
      ),
      GoRoute(
        path: '/emergency-card',
        builder: (context, state) => const EmergencyCardPage(),
      ),
      GoRoute(
        path: '/profiles',
        builder: (context, state) => const ProfilesPage(),
      ),
      GoRoute(
        path: '/reminders',
        builder: (context, state) => const RemindersPage(),
      ),
      GoRoute(
        path: '/subscription',
        builder: (context, state) => const SubscriptionPage(),
      ),
      GoRoute(
        path: '/privacy',
        builder: (context, state) => const PrivacyPage(),
      ),
    ],
  );
}
