class PrivacyModel {
  const PrivacyModel({
    this.termsAccepted = true,
    this.privacyAccepted = true,
    this.healthDataAccepted = true,
    this.aiProcessingAccepted = true,
    this.analyticsAccepted = false,
    this.qualityReviewAccepted = false,
  });

  final bool termsAccepted;
  final bool privacyAccepted;
  final bool healthDataAccepted;
  final bool aiProcessingAccepted;
  final bool analyticsAccepted;
  final bool qualityReviewAccepted;

  PrivacyModel copyWith({
    bool? termsAccepted,
    bool? privacyAccepted,
    bool? healthDataAccepted,
    bool? aiProcessingAccepted,
    bool? analyticsAccepted,
    bool? qualityReviewAccepted,
  }) {
    return PrivacyModel(
      termsAccepted: termsAccepted ?? this.termsAccepted,
      privacyAccepted: privacyAccepted ?? this.privacyAccepted,
      healthDataAccepted: healthDataAccepted ?? this.healthDataAccepted,
      aiProcessingAccepted: aiProcessingAccepted ?? this.aiProcessingAccepted,
      analyticsAccepted: analyticsAccepted ?? this.analyticsAccepted,
      qualityReviewAccepted:
          qualityReviewAccepted ?? this.qualityReviewAccepted,
    );
  }
}
