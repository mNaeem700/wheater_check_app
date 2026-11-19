# Visit Companion

Visit Companion is a safety-first Flutter app that helps users prepare for,
understand, and follow up on healthcare visits.

The app does not diagnose, prescribe, recommend doses, or replace a clinician.

## Current implementation

- Flutter + Dart
- MVVM architecture
- `ChangeNotifier` + `provider`
- `go_router` navigation
- Supabase integration hook (backend adapter pending)
- Firebase service abstractions (FCM, Analytics, Crashlytics, Remote Config
  adapters pending)
- Email/password authentication only
- No OTP or phone verification flow

## Feature modules

- Authentication
- Onboarding, language selection, and consent
- Profiles and offline emergency card
- Nearby care finder
- Pre-visit assistant with deterministic red-flag handling
- Post-visit document review and explanation
- Medication and follow-up reminders
- Subscription and entitlement UI
- Privacy dashboard, export, and account deletion

## Architecture

Each feature follows the same structure:

```text
lib/features/<feature>/
  data/          # Repository contracts and local implementations
  domain/        # Models and business rules
  presentation/  # Pages and ChangeNotifier ViewModels
```

Shared application infrastructure lives in:

```text
lib/
  app/           # Provider composition and MaterialApp
  core/          # Router, theme, config, service abstractions
  shared/        # Reusable presentation components
```

Repositories currently use in-memory implementations so the complete user
flows can be built and tested before backend integration. These will later be
replaced with Supabase-backed repositories without changing the UI contract.

## Run locally

```powershell
flutter pub get
flutter run
```

## Validate

```powershell
dart analyze
flutter test --no-pub --concurrency=1
```

## Planned backend integration

1. Supabase Auth for email/password sessions
2. PostgreSQL with Row-Level Security
3. Supabase Storage for private document originals
4. Supabase Edge Functions for AI/OCR orchestration
5. Firebase FCM, Analytics, Crashlytics, and Remote Config adapters
6. RevenueCat entitlement synchronization

Health data must not be logged to analytics or crash reporting. Safety-critical
features, emergency access, existing records, export, and account deletion
must remain available without a subscription.
