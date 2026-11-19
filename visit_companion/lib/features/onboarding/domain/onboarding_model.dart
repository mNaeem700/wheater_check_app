class OnboardingModel {
  const OnboardingModel({
    this.interfaceLanguage = 'en',
    this.homeLanguage = 'en',
    this.localLanguage = 'en',
    this.purpose = '',
    this.termsAccepted = false,
    this.privacyAccepted = false,
    this.healthDataAccepted = false,
    this.aiProcessingAccepted = false,
  });

  final String interfaceLanguage;
  final String homeLanguage;
  final String localLanguage;
  final String purpose;
  final bool termsAccepted;
  final bool privacyAccepted;
  final bool healthDataAccepted;
  final bool aiProcessingAccepted;

  bool get allRequiredConsentsAccepted =>
      termsAccepted &&
      privacyAccepted &&
      healthDataAccepted &&
      aiProcessingAccepted;

  OnboardingModel copyWith({
    String? interfaceLanguage,
    String? homeLanguage,
    String? localLanguage,
    String? purpose,
    bool? termsAccepted,
    bool? privacyAccepted,
    bool? healthDataAccepted,
    bool? aiProcessingAccepted,
  }) {
    return OnboardingModel(
      interfaceLanguage: interfaceLanguage ?? this.interfaceLanguage,
      homeLanguage: homeLanguage ?? this.homeLanguage,
      localLanguage: localLanguage ?? this.localLanguage,
      purpose: purpose ?? this.purpose,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      privacyAccepted: privacyAccepted ?? this.privacyAccepted,
      healthDataAccepted: healthDataAccepted ?? this.healthDataAccepted,
      aiProcessingAccepted: aiProcessingAccepted ?? this.aiProcessingAccepted,
    );
  }
}
