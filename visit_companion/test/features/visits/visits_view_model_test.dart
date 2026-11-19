import 'package:flutter_test/flutter_test.dart';
import 'package:visit_companion/features/visits/data/visit_repository.dart';
import 'package:visit_companion/features/visits/presentation/visits_view_model.dart';

void main() {
  test('visit draft requires reason, onset and severity', () async {
    final viewModel = VisitsViewModel(InMemoryVisitRepository());

    expect(await viewModel.saveDraft(), isFalse);

    viewModel.setReason('Recurring headache');
    viewModel.setOnset('Yesterday');
    viewModel.setSeverity('Moderate');

    expect(await viewModel.saveDraft(), isTrue);
    expect(viewModel.visits, hasLength(1));
  });

  test('deterministic red flags interrupt the visit flow', () {
    final viewModel = VisitsViewModel(InMemoryVisitRepository());

    expect(viewModel.hasRedFlag('Severe chest pain'), isTrue);
    expect(viewModel.hasRedFlag('Difficulty breathing'), isTrue);
    expect(viewModel.hasRedFlag('Thoughts of self harm'), isTrue);
    expect(viewModel.hasRedFlag('Mild headache'), isFalse);
  });

  test('saved visit can be deleted', () async {
    final viewModel = VisitsViewModel(InMemoryVisitRepository());
    viewModel.setReason('Lab appointment');
    viewModel.setOnset('Today');
    viewModel.setSeverity('Mild');
    await viewModel.saveDraft();

    final id = viewModel.visits.first.id;
    await viewModel.deleteVisit(id);

    expect(viewModel.visits, isEmpty);
  });
}
