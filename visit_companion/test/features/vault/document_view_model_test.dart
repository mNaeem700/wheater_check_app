import 'package:flutter_test/flutter_test.dart';
import 'package:visit_companion/features/vault/data/document_repository.dart';
import 'package:visit_companion/features/vault/presentation/vault_view_model.dart';

void main() {
  test('document cannot explain before title and corrected text', () async {
    final viewModel = VaultViewModel(InMemoryDocumentRepository());

    expect(await viewModel.saveDocument(), isFalse);

    viewModel.setTitle('Prescription');
    viewModel.setOriginalText('Sample medicine text');

    expect(await viewModel.saveDocument(), isTrue);
  });

  test('reminder is created only after explicit approval', () {
    final viewModel = VaultViewModel(InMemoryDocumentRepository());

    expect(viewModel.reminderApproved, isFalse);

    viewModel.setReminderApproved(true);

    expect(viewModel.reminderApproved, isTrue);
  });

  test('missing medication dose or duration is not inferred', () {
    final viewModel = VaultViewModel(InMemoryDocumentRepository());

    viewModel.setMedicationName('Example Medicine');

    expect(viewModel.medication.name, 'Example Medicine');
    expect(viewModel.medication.strength, isEmpty);
    expect(viewModel.medication.frequency, isEmpty);
    expect(viewModel.medication.duration, isEmpty);
  });
}
