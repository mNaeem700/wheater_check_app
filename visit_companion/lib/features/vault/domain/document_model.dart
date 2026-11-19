class DocumentModel {
  const DocumentModel({
    this.id = '',
    this.title = '',
    this.originalText = '',
    this.correctedText = '',
    this.explanation = '',
    this.reportProblem = false,
  });

  final String id;
  final String title;
  final String originalText;
  final String correctedText;
  final String explanation;
  final bool reportProblem;

  bool get canExplain =>
      title.trim().isNotEmpty && correctedText.trim().isNotEmpty;

  DocumentModel copyWith({
    String? id,
    String? title,
    String? originalText,
    String? correctedText,
    String? explanation,
    bool? reportProblem,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      originalText: originalText ?? this.originalText,
      correctedText: correctedText ?? this.correctedText,
      explanation: explanation ?? this.explanation,
      reportProblem: reportProblem ?? this.reportProblem,
    );
  }
}

class MedicationDraftModel {
  const MedicationDraftModel({
    this.name = '',
    this.strength = '',
    this.frequency = '',
    this.duration = '',
  });

  final String name;
  final String strength;
  final String frequency;
  final String duration;

  bool get hasAnyValue =>
      name.isNotEmpty ||
      strength.isNotEmpty ||
      frequency.isNotEmpty ||
      duration.isNotEmpty;

  MedicationDraftModel copyWith({
    String? name,
    String? strength,
    String? frequency,
    String? duration,
  }) {
    return MedicationDraftModel(
      name: name ?? this.name,
      strength: strength ?? this.strength,
      frequency: frequency ?? this.frequency,
      duration: duration ?? this.duration,
    );
  }
}
