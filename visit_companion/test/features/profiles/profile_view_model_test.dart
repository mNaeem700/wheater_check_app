import 'package:flutter_test/flutter_test.dart';
import 'package:visit_companion/features/profiles/data/profile_repository.dart';
import 'package:visit_companion/features/profiles/presentation/profile_view_model.dart';

void main() {
  test('profile draft requires name, country and language', () async {
    final viewModel = ProfileViewModel(InMemoryProfileRepository());

    expect(await viewModel.saveDraft(), isFalse);

    viewModel.setName('Ayesha');
    viewModel.setCountry('United Kingdom');
    viewModel.setLanguages(['Urdu']);

    expect(await viewModel.saveDraft(), isTrue);
    expect(viewModel.profiles, hasLength(1));
  });

  test('profile can be edited and deleted', () async {
    final viewModel = ProfileViewModel(InMemoryProfileRepository());
    viewModel.setName('Bilal');
    viewModel.setCountry('United Kingdom');
    viewModel.setLanguages(['English']);
    await viewModel.saveDraft();

    final savedProfile = viewModel.profiles.first;
    viewModel.editProfile(savedProfile);
    viewModel.setName('Bilal Khan');
    await viewModel.saveDraft();

    expect(viewModel.profiles.first.name, 'Bilal Khan');

    await viewModel.deleteProfile(savedProfile.id);
    expect(viewModel.profiles, isEmpty);
  });
}
