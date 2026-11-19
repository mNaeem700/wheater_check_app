import '../domain/visit_model.dart';

abstract interface class VisitRepository {
  Future<List<VisitModel>> loadVisits();

  Future<void> saveVisit(VisitModel visit);

  Future<void> deleteVisit(String id);
}

class InMemoryVisitRepository implements VisitRepository {
  final List<VisitModel> _visits = [];

  @override
  Future<void> deleteVisit(String id) async {
    _visits.removeWhere((visit) => visit.id == id);
  }

  @override
  Future<List<VisitModel>> loadVisits() async {
    return List<VisitModel>.unmodifiable(_visits);
  }

  @override
  Future<void> saveVisit(VisitModel visit) async {
    final index = _visits.indexWhere((item) => item.id == visit.id);
    if (index >= 0) {
      _visits[index] = visit;
    } else {
      _visits.add(visit);
    }
  }
}
