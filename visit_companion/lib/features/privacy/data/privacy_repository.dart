import '../domain/privacy_model.dart';

abstract interface class PrivacyRepository {
  Future<PrivacyModel> load();

  Future<void> save(PrivacyModel model);

  Future<String> exportData();

  Future<void> deleteAccount();
}

class InMemoryPrivacyRepository implements PrivacyRepository {
  PrivacyModel _model = const PrivacyModel();
  bool _deleted = false;

  @override
  Future<void> deleteAccount() async {
    _model = const PrivacyModel(
      termsAccepted: false,
      privacyAccepted: false,
      healthDataAccepted: false,
      aiProcessingAccepted: false,
    );
    _deleted = true;
  }

  @override
  Future<String> exportData() async {
    return '{"profile": {}, "documents": [], "visits": [], '
        '"reminders": [], "consents": {'
        '"analytics": ${_model.analyticsAccepted}, '
        '"aiProcessing": ${_model.aiProcessingAccepted}}}';
  }

  @override
  Future<PrivacyModel> load() async => _deleted
      ? const PrivacyModel(
          termsAccepted: false,
          privacyAccepted: false,
          healthDataAccepted: false,
          aiProcessingAccepted: false,
        )
      : _model;

  @override
  Future<void> save(PrivacyModel model) async {
    _model = model;
    _deleted = false;
  }
}
