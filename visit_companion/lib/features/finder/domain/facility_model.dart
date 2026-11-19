class FacilityModel {
  const FacilityModel({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.distanceKm,
    required this.languages,
    required this.isOpen,
    required this.phone,
  });

  final String id;
  final String name;
  final String type;
  final String address;
  final double distanceKm;
  final List<String> languages;
  final bool isOpen;
  final String phone;
}
