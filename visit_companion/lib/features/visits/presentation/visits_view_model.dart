import 'package:flutter/foundation.dart';

import '../data/visit_repository.dart';
import '../domain/visit_model.dart';

class VisitsViewModel extends ChangeNotifier {
  VisitsViewModel(this._repository);

  final VisitRepository _repository;

  VisitModel _draft = const VisitModel();
  List<VisitModel> _visits = [];
  bool _isLoading = false;

  VisitModel get draft => _draft;
  List<VisitModel> get visits => _visits;
  bool get isLoading => _isLoading;

  Future<void> loadVisits() async {
    _isLoading = true;
    notifyListeners();
    _visits = await _repository.loadVisits();
    _isLoading = false;
    notifyListeners();
  }

  void startVisit() {
    _draft = const VisitModel();
    notifyListeners();
  }

  void setReason(String value) {
    _draft = _draft.copyWith(reason: value);
    notifyListeners();
  }

  void setOnset(String value) {
    _draft = _draft.copyWith(onset: value);
    notifyListeners();
  }

  void setDuration(String value) {
    _draft = _draft.copyWith(duration: value);
    notifyListeners();
  }

  void setSeverity(String value) {
    _draft = _draft.copyWith(severity: value);
    notifyListeners();
  }

  void setLocationOnBody(String value) {
    _draft = _draft.copyWith(locationOnBody: value);
    notifyListeners();
  }

  void setTriggers(String value) {
    _draft = _draft.copyWith(triggers: value);
    notifyListeners();
  }

  void setMedicinesTried(String value) {
    _draft = _draft.copyWith(medicinesTried: value);
    notifyListeners();
  }

  void setAllergies(String value) {
    _draft = _draft.copyWith(allergies: value);
    notifyListeners();
  }

  void setQuestions(String value) {
    _draft = _draft.copyWith(questions: value);
    notifyListeners();
  }

  bool hasRedFlag(String text) {
    final value = text.toLowerCase();
    const phrases = [
      'chest pain',
      'difficulty breathing',
      'cant breathe',
      'cannot breathe',
      'severe bleeding',
      'stroke',
      'suicide',
      'self harm',
      'self-harm',
      'unconscious',
      'anaphylaxis',
    ];
    return phrases.any(value.contains);
  }

  Future<bool> saveDraft() async {
    if (!_draft.canCreateSummary) return false;
    if (hasRedFlag(
      '${_draft.reason} ${_draft.severity} ${_draft.locationOnBody}',
    )) {
      return false;
    }

    final id = _draft.id.isEmpty
        ? DateTime.now().microsecondsSinceEpoch.toString()
        : _draft.id;
    await _repository.saveVisit(_draft.copyWith(id: id));
    await loadVisits();
    _draft = const VisitModel();
    notifyListeners();
    return true;
  }

  Future<void> deleteVisit(String id) async {
    await _repository.deleteVisit(id);
    await loadVisits();
  }
}
