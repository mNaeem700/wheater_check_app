import 'package:flutter/foundation.dart';

import '../data/reminder_repository.dart';
import '../domain/reminder_model.dart';

class ReminderViewModel extends ChangeNotifier {
  ReminderViewModel(this._repository);

  final ReminderRepository _repository;

  List<ReminderModel> _reminders = [];
  ReminderModel _draft = ReminderModel(
    title: '',
    type: ReminderType.medication,
    scheduledAt: DateTime.now().add(const Duration(hours: 1)),
  );
  bool _isLoading = false;

  List<ReminderModel> get reminders => _reminders;
  ReminderModel get draft => _draft;
  bool get isLoading => _isLoading;

  Future<void> loadReminders() async {
    _isLoading = true;
    notifyListeners();

    _reminders = await _repository.loadReminders();

    _isLoading = false;
    notifyListeners();
  }

  void startReminder() {
    _draft = ReminderModel(
      title: '',
      type: ReminderType.medication,
      scheduledAt: DateTime.now().add(const Duration(hours: 1)),
    );
    notifyListeners();
  }

  void setTitle(String value) {
    _draft = _draft.copyWith(title: value);
    notifyListeners();
  }

  void setType(ReminderType value) {
    _draft = _draft.copyWith(type: value);
    notifyListeners();
  }

  void setScheduledAt(DateTime value) {
    _draft = _draft.copyWith(scheduledAt: value);
    notifyListeners();
  }

  void setProfileName(String value) {
    _draft = _draft.copyWith(profileName: value);
    notifyListeners();
  }

  void setNote(String value) {
    _draft = _draft.copyWith(note: value);
    notifyListeners();
  }

  Future<bool> saveDraft() async {
    if (!_draft.isValid) return false;

    final id = _draft.id.isEmpty
        ? DateTime.now().microsecondsSinceEpoch.toString()
        : _draft.id;
    await _repository.saveReminder(_draft.copyWith(id: id));
    await loadReminders();
    return true;
  }

  Future<void> updateStatus(
    ReminderModel reminder,
    ReminderStatus status,
  ) async {
    await _repository.saveReminder(reminder.copyWith(status: status));
    await loadReminders();
  }

  Future<void> snooze(ReminderModel reminder) async {
    await _repository.saveReminder(
      reminder.copyWith(
        scheduledAt: DateTime.now().add(const Duration(minutes: 15)),
        status: ReminderStatus.snoozed,
      ),
    );
    await loadReminders();
  }

  Future<void> deleteReminder(String id) async {
    await _repository.deleteReminder(id);
    await loadReminders();
  }
}
