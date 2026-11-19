import '../domain/facility_model.dart';

abstract interface class FacilityRepository {
  Future<List<FacilityModel>> search({
    required String location,
    required String type,
    required bool openNow,
    required String language,
  });
}

class InMemoryFacilityRepository implements FacilityRepository {
  static const _facilities = [
    FacilityModel(
      id: 'clinic-1',
      name: 'Riverside Community Clinic',
      type: 'Clinic',
      address: '14 River Street',
      distanceKm: 1.2,
      languages: ['English', 'Urdu'],
      isOpen: true,
      phone: '+44 0000 000001',
    ),
    FacilityModel(
      id: 'clinic-2',
      name: 'Northside Medical Centre',
      type: 'Clinic',
      address: '28 North Road',
      distanceKm: 2.8,
      languages: ['English'],
      isOpen: false,
      phone: '+44 0000 000002',
    ),
    FacilityModel(
      id: 'pharmacy-1',
      name: 'Care Plus Pharmacy',
      type: 'Pharmacy',
      address: '5 Market Avenue',
      distanceKm: 0.8,
      languages: ['English', 'Urdu'],
      isOpen: true,
      phone: '+44 0000 000003',
    ),
    FacilityModel(
      id: 'lab-1',
      name: 'Central Diagnostics Lab',
      type: 'Lab',
      address: '9 High Street',
      distanceKm: 3.4,
      languages: ['English'],
      isOpen: true,
      phone: '+44 0000 000004',
    ),
  ];

  @override
  Future<List<FacilityModel>> search({
    required String location,
    required String type,
    required bool openNow,
    required String language,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    return _facilities.where((facility) {
      final typeMatches =
          type == 'All' || facility.type.toLowerCase() == type.toLowerCase();
      final openMatches = !openNow || facility.isOpen;
      final languageMatches =
          language == 'Any' || facility.languages.contains(language);
      return typeMatches && openMatches && languageMatches;
    }).toList();
  }
}
