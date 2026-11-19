import 'package:flutter_test/flutter_test.dart';
import 'package:visit_companion/features/reminders/data/reminder_repository.dart';
import 'package:visit_companion/features/reminders/domain/reminder_model.dart';
import 'package:visit_companion/features/reminders/presentation/reminder_view_model.dart';

void main() {
  test('reminder requires title and future schedule', () async {
    final viewModel = ReminderViewModel(InMemoryReminderRepository());

    expect(await viewModel.saveDraft(), isFalse);

    viewModel.setTitle('Morning medicine');
    viewModel.setScheduledAt(DateTime.now().add(const Duration(hours: 2)));

    expect(await viewModel.saveDraft(), isTrue);
    expect(viewModel.reminders, hasLength(1));
  });

  test('reminder can be snoozed and completed', () async {
    final viewModel = ReminderViewModel(InMemoryReminderRepository());
    viewModel.setTitle('Follow-up');
    viewModel.setType(ReminderType.followUp);
    viewModel.setScheduledAt(DateTime.now().add(const Duration(hours: 3)));
    await viewModel.saveDraft();

    final reminder = viewModel.reminders.first;
    await viewModel.snooze(reminder);

    expect(viewModel.reminders.first.status, ReminderStatus.snoozed);

    await viewModel.updateStatus(
      viewModel.reminders.first,
      ReminderStatus.completed,
    );

    expect(viewModel.reminders.first.status, ReminderStatus.completed);
  });
}
