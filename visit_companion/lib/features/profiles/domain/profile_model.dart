class ProfileModel {
  const ProfileModel({
    this.id = '',
    this.name = '',
    this.dateOfBirth,
    this.sex = '',
    this.languages = const [],
    this.country = '',
    this.region = '',
    this.allergies = const [],
    this.conditions = const [],
    this.medicines = const [],
    this.isMinor = false,
  });

  final String id;
  final String name;
  final DateTime? dateOfBirth;
  final String sex;
  final List<String> languages;
  final String country;
  final String region;
  final List<String> allergies;
  final List<String> conditions;
  final List<String> medicines;
  final bool isMinor;

  bool get isValid =>
      name.trim().isNotEmpty &&
      country.trim().isNotEmpty &&
      languages.isNotEmpty;

  ProfileModel copyWith({
    String? id,
    String? name,
    DateTime? dateOfBirth,
    String? sex,
    List<String>? languages,
    String? country,
    String? region,
    List<String>? allergies,
    List<String>? conditions,
    List<String>? medicines,
    bool? isMinor,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      sex: sex ?? this.sex,
      languages: languages ?? this.languages,
      country: country ?? this.country,
      region: region ?? this.region,
      allergies: allergies ?? this.allergies,
      conditions: conditions ?? this.conditions,
      medicines: medicines ?? this.medicines,
      isMinor: isMinor ?? this.isMinor,
    );
  }
}
