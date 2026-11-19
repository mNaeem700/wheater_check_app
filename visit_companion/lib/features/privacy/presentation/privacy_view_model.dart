import 'package:flutter/foundation.dart';

import '../data/privacy_repository.dart';
import '../domain/privacy_model.dart';

class PrivacyViewModel extends ChangeNotifier {
  PrivacyViewModel(this._repository);

  final PrivacyRepository _repository;

  PrivacyModel _model = const PrivacyModel();
  bool _isLoading = false;
  bool _isDeleted = false;
  String? _lastExport;

  PrivacyModel get model => _model;
  bool get isLoading => _isLoading;
  bool get isDeleted => _isDeleted;
  String? get lastExport => _lastExport;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _model = await _repository.load();
    _isDeleted = false;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setAnalyticsAccepted(bool value) async {
    await _save(_model.copyWith(analyticsAccepted: value));
  }

  Future<void> setQualityReviewAccepted(bool value) async {
    await _save(_model.copyWith(qualityReviewAccepted: value));
  }

  Future<String> exportData() async {
    _lastExport = await _repository.exportData();
    notifyListeners();
    return _lastExport!;
  }

  Future<void> deleteAccount() async {
    await _repository.deleteAccount();
    _isDeleted = true;
    _model = await _repository.load();
    notifyListeners();
  }

  Future<void> _save(PrivacyModel model) async {
    await _repository.save(model);
    _model = model;
    notifyListeners();
  }
}
