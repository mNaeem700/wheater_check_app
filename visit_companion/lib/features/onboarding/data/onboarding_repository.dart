import '../domain/onboarding_model.dart';

abstract interface class OnboardingRepository {
  Future<OnboardingModel?> load();

  Future<void> save(OnboardingModel model);

  Future<void> clear();
}

class InMemoryOnboardingRepository implements OnboardingRepository {
  OnboardingModel? _model;

  @override
  Future<void> clear() async {
    _model = null;
  }

  @override
  Future<OnboardingModel?> load() async {
    return _model;
  }

  @override
  Future<void> save(OnboardingModel model) async {
    _model = model;
  }
}
