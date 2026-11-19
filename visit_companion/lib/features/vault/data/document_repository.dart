import '../domain/document_model.dart';

abstract interface class DocumentRepository {
  Future<List<DocumentModel>> loadDocuments();

  Future<void> saveDocument(DocumentModel document);

  Future<void> deleteDocument(String id);
}

class InMemoryDocumentRepository implements DocumentRepository {
  final List<DocumentModel> _documents = [];

  @override
  Future<void> deleteDocument(String id) async {
    _documents.removeWhere((document) => document.id == id);
  }

  @override
  Future<List<DocumentModel>> loadDocuments() async {
    return List<DocumentModel>.unmodifiable(_documents);
  }

  @override
  Future<void> saveDocument(DocumentModel document) async {
    final index = _documents.indexWhere((item) => item.id == document.id);
    if (index >= 0) {
      _documents[index] = document;
    } else {
      _documents.add(document);
    }
  }
}
