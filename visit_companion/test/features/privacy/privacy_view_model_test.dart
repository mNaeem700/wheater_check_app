import 'package:flutter_test/flutter_test.dart';
import 'package:visit_companion/features/privacy/data/privacy_repository.dart';
import 'package:visit_companion/features/privacy/presentation/privacy_view_model.dart';

void main() {
  test('optional analytics consent can be changed', () async {
    final viewModel = PrivacyViewModel(InMemoryPrivacyRepository());
    await viewModel.load();

    expect(viewModel.model.analyticsAccepted, isFalse);
    await viewModel.setAnalyticsAccepted(true);
    expect(viewModel.model.analyticsAccepted, isTrue);
  });

  test('export returns data without requiring optional analytics', () async {
    final viewModel = PrivacyViewModel(InMemoryPrivacyRepository());
    await viewModel.load();

    final export = await viewModel.exportData();

    expect(export, contains('"profile"'));
    expect(export, contains('"analytics": false'));
  });

  test('delete account clears required consent state', () async {
    final viewModel = PrivacyViewModel(InMemoryPrivacyRepository());
    await viewModel.load();

    await viewModel.deleteAccount();

    expect(viewModel.isDeleted, isTrue);
    expect(viewModel.model.healthDataAccepted, isFalse);
    expect(viewModel.model.aiProcessingAccepted, isFalse);
  });
}
