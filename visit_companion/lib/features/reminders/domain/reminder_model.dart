enum ReminderType { medication, followUp, refill }

enum ReminderStatus { active, completed, snoozed, skipped }

class ReminderModel {
  const ReminderModel({
    this.id = '',
    required this.title,
    required this.type,
    required this.scheduledAt,
    this.profileName = '',
    this.note = '',
    this.status = ReminderStatus.active,
  });

  final String id;
  final String title;
  final ReminderType type;
  final DateTime scheduledAt;
  final String profileName;
  final String note;
  final ReminderStatus status;

  bool get isValid =>
      title.trim().isNotEmpty && scheduledAt.isAfter(DateTime.now());

  ReminderModel copyWith({
    String? id,
    String? title,
    ReminderType? type,
    DateTime? scheduledAt,
    String? profileName,
    String? note,
    ReminderStatus? status,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      profileName: profileName ?? this.profileName,
      note: note ?? this.note,
      status: status ?? this.status,
    );
  }
}
