import 'package:flutter/foundation.dart';

import '../data/document_repository.dart';
import '../domain/document_model.dart';

class VaultViewModel extends ChangeNotifier {
  VaultViewModel(this._repository);

  final DocumentRepository _repository;

  List<DocumentModel> _documents = [];
  DocumentModel _draft = const DocumentModel();
  MedicationDraftModel _medication = const MedicationDraftModel();
  bool _isLoading = false;
  bool _reminderApproved = false;

  List<DocumentModel> get documents => _documents;
  DocumentModel get draft => _draft;
  MedicationDraftModel get medication => _medication;
  bool get isLoading => _isLoading;
  bool get reminderApproved => _reminderApproved;

  Future<void> loadDocuments() async {
    _isLoading = true;
    notifyListeners();

    _documents = await _repository.loadDocuments();

    _isLoading = false;
    notifyListeners();
  }

  void startDocument() {
    _draft = const DocumentModel();
    _medication = const MedicationDraftModel();
    _reminderApproved = false;
    notifyListeners();
  }

  void setTitle(String value) {
    _draft = _draft.copyWith(title: value);
    notifyListeners();
  }

  void setOriginalText(String value) {
    _draft = _draft.copyWith(originalText: value, correctedText: value);
    notifyListeners();
  }

  void setCorrectedText(String value) {
    _draft = _draft.copyWith(correctedText: value);
    notifyListeners();
  }

  void setMedicationName(String value) {
    _medication = _medication.copyWith(name: value);
    notifyListeners();
  }

  void setMedicationStrength(String value) {
    _medication = _medication.copyWith(strength: value);
    notifyListeners();
  }

  void setMedicationFrequency(String value) {
    _medication = _medication.copyWith(frequency: value);
    notifyListeners();
  }

  void setMedicationDuration(String value) {
    _medication = _medication.copyWith(duration: value);
    notifyListeners();
  }

  void setReminderApproved(bool value) {
    _reminderApproved = value;
    notifyListeners();
  }

  Future<bool> saveDocument() async {
    if (!_draft.canExplain) return false;

    final id = _draft.id.isEmpty
        ? DateTime.now().microsecondsSinceEpoch.toString()
        : _draft.id;
    final explanation = _buildLocalExplanation(_draft.correctedText);
    await _repository.saveDocument(
      _draft.copyWith(id: id, explanation: explanation),
    );
    await loadDocuments();
    return true;
  }

  String _buildLocalExplanation(String text) {
    if (text.trim().isEmpty) return '';
    return 'Review the extracted text beside the original. '
        'This app does not change medicine doses or advise stopping, '
        'starting or combining medicines. Confirm uncertain details '
        'with a clinician or pharmacist.';
  }

  Future<void> deleteDocument(String id) async {
    await _repository.deleteDocument(id);
    await loadDocuments();
  }
}
