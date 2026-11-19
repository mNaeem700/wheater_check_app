import 'package:flutter/foundation.dart';

import '../data/facility_repository.dart';
import '../domain/facility_model.dart';

class FinderViewModel extends ChangeNotifier {
  FinderViewModel(this._repository);

  final FacilityRepository _repository;

  String _location = '';
  String _facilityType = 'All';
  String _language = 'Any';
  bool _openNow = false;
  bool _isLoading = false;
  List<FacilityModel> _results = [];

  String get location => _location;
  String get facilityType => _facilityType;
  String get language => _language;
  bool get openNow => _openNow;
  bool get isLoading => _isLoading;
  List<FacilityModel> get results => _results;

  void setLocation(String value) {
    _location = value;
    notifyListeners();
  }

  void setFacilityType(String value) {
    _facilityType = value;
    notifyListeners();
  }

  void setLanguage(String value) {
    _language = value;
    notifyListeners();
  }

  void setOpenNow(bool value) {
    _openNow = value;
    notifyListeners();
  }

  Future<void> search() async {
    _isLoading = true;
    notifyListeners();

    _results = await _repository.search(
      location: _location,
      type: _facilityType,
      openNow: _openNow,
      language: _language,
    );

    _isLoading = false;
    notifyListeners();
  }
}
