class VisitModel {
  const VisitModel({
    this.id = '',
    this.profileName = '',
    this.reason = '',
    this.onset = '',
    this.duration = '',
    this.severity = '',
    this.locationOnBody = '',
    this.triggers = '',
    this.medicinesTried = '',
    this.allergies = '',
    this.questions = '',
    this.sourceLanguage = 'English',
    this.targetLanguage = 'Urdu',
  });

  final String id;
  final String profileName;
  final String reason;
  final String onset;
  final String duration;
  final String severity;
  final String locationOnBody;
  final String triggers;
  final String medicinesTried;
  final String allergies;
  final String questions;
  final String sourceLanguage;
  final String targetLanguage;

  bool get canCreateSummary =>
      reason.trim().isNotEmpty &&
      severity.trim().isNotEmpty &&
      onset.trim().isNotEmpty;

  VisitModel copyWith({
    String? id,
    String? profileName,
    String? reason,
    String? onset,
    String? duration,
    String? severity,
    String? locationOnBody,
    String? triggers,
    String? medicinesTried,
    String? allergies,
    String? questions,
    String? sourceLanguage,
    String? targetLanguage,
  }) {
    return VisitModel(
      id: id ?? this.id,
      profileName: profileName ?? this.profileName,
      reason: reason ?? this.reason,
      onset: onset ?? this.onset,
      duration: duration ?? this.duration,
      severity: severity ?? this.severity,
      locationOnBody: locationOnBody ?? this.locationOnBody,
      triggers: triggers ?? this.triggers,
      medicinesTried: medicinesTried ?? this.medicinesTried,
      allergies: allergies ?? this.allergies,
      questions: questions ?? this.questions,
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
    );
  }
}
