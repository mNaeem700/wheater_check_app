import 'package:flutter/foundation.dart';

import '../data/profile_repository.dart';
import '../domain/profile_model.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel(this._repository);

  final ProfileRepository _repository;

  List<ProfileModel> _profiles = [];
  ProfileModel _draft = const ProfileModel();
  bool _isLoading = false;

  List<ProfileModel> get profiles => _profiles;
  ProfileModel get draft => _draft;
  bool get isLoading => _isLoading;

  Future<void> loadProfiles() async {
    _isLoading = true;
    notifyListeners();

    _profiles = await _repository.loadProfiles();

    _isLoading = false;
    notifyListeners();
  }

  void startNewProfile() {
    _draft = const ProfileModel();
    notifyListeners();
  }

  void editProfile(ProfileModel profile) {
    _draft = profile;
    notifyListeners();
  }

  void setName(String value) {
    _draft = _draft.copyWith(name: value);
    notifyListeners();
  }

  void setDateOfBirth(DateTime value) {
    _draft = _draft.copyWith(dateOfBirth: value);
    notifyListeners();
  }

  void setSex(String value) {
    _draft = _draft.copyWith(sex: value);
    notifyListeners();
  }

  void setLanguages(List<String> values) {
    _draft = _draft.copyWith(languages: values);
    notifyListeners();
  }

  void setCountry(String value) {
    _draft = _draft.copyWith(country: value);
    notifyListeners();
  }

  void setRegion(String value) {
    _draft = _draft.copyWith(region: value);
    notifyListeners();
  }

  void setAllergies(List<String> values) {
    _draft = _draft.copyWith(allergies: values);
    notifyListeners();
  }

  void setConditions(List<String> values) {
    _draft = _draft.copyWith(conditions: values);
    notifyListeners();
  }

  void setMedicines(List<String> values) {
    _draft = _draft.copyWith(medicines: values);
    notifyListeners();
  }

  void setIsMinor(bool value) {
    _draft = _draft.copyWith(isMinor: value);
    notifyListeners();
  }

  Future<bool> saveDraft() async {
    if (!_draft.isValid) return false;

    final id = _draft.id.isEmpty
        ? DateTime.now().microsecondsSinceEpoch.toString()
        : _draft.id;
    await _repository.saveProfile(_draft.copyWith(id: id));
    await loadProfiles();
    _draft = const ProfileModel();
    notifyListeners();
    return true;
  }

  Future<void> deleteProfile(String id) async {
    await _repository.deleteProfile(id);
    await loadProfiles();
  }
}
