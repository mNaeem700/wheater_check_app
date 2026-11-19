import 'package:flutter_test/flutter_test.dart';
import 'package:visit_companion/features/finder/data/facility_repository.dart';
import 'package:visit_companion/features/finder/presentation/finder_view_model.dart';

void main() {
  test('finder filters pharmacies and open facilities', () async {
    final viewModel = FinderViewModel(InMemoryFacilityRepository());

    viewModel.setLocation('Manchester');
    viewModel.setFacilityType('Pharmacy');
    viewModel.setLanguage('Urdu');
    viewModel.setOpenNow(true);
    await viewModel.search();

    expect(viewModel.results, hasLength(1));
    expect(viewModel.results.first.name, 'Care Plus Pharmacy');
  });

  test('finder can list all facilities', () async {
    final viewModel = FinderViewModel(InMemoryFacilityRepository());

    await viewModel.search();

    expect(viewModel.results, hasLength(4));
  });
}
