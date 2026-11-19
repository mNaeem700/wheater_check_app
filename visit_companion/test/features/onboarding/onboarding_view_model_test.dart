import 'package:flutter_test/flutter_test.dart';
import 'package:visit_companion/features/onboarding/data/onboarding_repository.dart';
import 'package:visit_companion/features/onboarding/presentation/onboarding_view_model.dart';

void main() {
  test('onboarding requires purpose and all consents', () async {
    final viewModel = OnboardingViewModel(InMemoryOnboardingRepository());

    expect(await viewModel.completeOnboarding(), isFalse);

    viewModel.setPurpose('Prepare for a clinic visit');
    viewModel.setTermsAccepted(true);
    viewModel.setPrivacyAccepted(true);
    viewModel.setHealthDataAccepted(true);
    viewModel.setAiProcessingAccepted(true);

    expect(await viewModel.completeOnboarding(), isTrue);
  });

  test('saved onboarding state can be loaded', () async {
    final repository = InMemoryOnboardingRepository();
    final viewModel = OnboardingViewModel(repository);

    viewModel.setInterfaceLanguage('ur');
    viewModel.setPurpose('Manage family health records');
    viewModel.setTermsAccepted(true);
    viewModel.setPrivacyAccepted(true);
    viewModel.setHealthDataAccepted(true);
    viewModel.setAiProcessingAccepted(true);
    await viewModel.completeOnboarding();

    final loadedViewModel = OnboardingViewModel(repository);
    await loadedViewModel.load();

    expect(loadedViewModel.model.interfaceLanguage, 'ur');
    expect(loadedViewModel.model.purpose, 'Manage family health records');
  });
}
