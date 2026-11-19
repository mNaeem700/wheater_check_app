import '../domain/reminder_model.dart';

abstract interface class ReminderRepository {
  Future<List<ReminderModel>> loadReminders();

  Future<void> saveReminder(ReminderModel reminder);

  Future<void> deleteReminder(String id);
}

class InMemoryReminderRepository implements ReminderRepository {
  final List<ReminderModel> _reminders = [];

  @override
  Future<void> deleteReminder(String id) async {
    _reminders.removeWhere((reminder) => reminder.id == id);
  }

  @override
  Future<List<ReminderModel>> loadReminders() async {
    return List<ReminderModel>.unmodifiable(_reminders);
  }

  @override
  Future<void> saveReminder(ReminderModel reminder) async {
    final index = _reminders.indexWhere((item) => item.id == reminder.id);
    if (index >= 0) {
      _reminders[index] = reminder;
    } else {
      _reminders.add(reminder);
    }
  }
}
