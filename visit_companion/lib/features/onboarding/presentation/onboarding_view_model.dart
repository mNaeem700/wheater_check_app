import 'package:flutter/foundation.dart';

import '../data/onboarding_repository.dart';
import '../domain/onboarding_model.dart';

class OnboardingViewModel extends ChangeNotifier {
  OnboardingViewModel(this._repository);

  final OnboardingRepository _repository;

  OnboardingModel _model = const OnboardingModel();
  bool _isLoading = false;

  OnboardingModel get model => _model;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _model = await _repository.load() ?? const OnboardingModel();

    _isLoading = false;
    notifyListeners();
  }

  void setInterfaceLanguage(String value) {
    _model = _model.copyWith(interfaceLanguage: value);
    notifyListeners();
  }

  void setHomeLanguage(String value) {
    _model = _model.copyWith(homeLanguage: value);
    notifyListeners();
  }

  void setLocalLanguage(String value) {
    _model = _model.copyWith(localLanguage: value);
    notifyListeners();
  }

  void setPurpose(String value) {
    _model = _model.copyWith(purpose: value);
    notifyListeners();
  }

  void setTermsAccepted(bool value) {
    _model = _model.copyWith(termsAccepted: value);
    notifyListeners();
  }

  void setPrivacyAccepted(bool value) {
    _model = _model.copyWith(privacyAccepted: value);
    notifyListeners();
  }

  void setHealthDataAccepted(bool value) {
    _model = _model.copyWith(healthDataAccepted: value);
    notifyListeners();
  }

  void setAiProcessingAccepted(bool value) {
    _model = _model.copyWith(aiProcessingAccepted: value);
    notifyListeners();
  }

  Future<bool> completeOnboarding() async {
    if (_model.purpose.isEmpty || !_model.allRequiredConsentsAccepted) {
      return false;
    }

    await _repository.save(_model);
    return true;
  }

  Future<void> reset() async {
    await _repository.clear();
    _model = const OnboardingModel();
    notifyListeners();
  }
}
