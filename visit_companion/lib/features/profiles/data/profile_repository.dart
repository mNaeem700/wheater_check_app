import '../domain/profile_model.dart';

abstract interface class ProfileRepository {
  Future<List<ProfileModel>> loadProfiles();

  Future<void> saveProfile(ProfileModel profile);

  Future<void> deleteProfile(String id);
}

class InMemoryProfileRepository implements ProfileRepository {
  final List<ProfileModel> _profiles = [];

  @override
  Future<void> deleteProfile(String id) async {
    _profiles.removeWhere((profile) => profile.id == id);
  }

  @override
  Future<List<ProfileModel>> loadProfiles() async {
    return List<ProfileModel>.unmodifiable(_profiles);
  }

  @override
  Future<void> saveProfile(ProfileModel profile) async {
    final index = _profiles.indexWhere((item) => item.id == profile.id);
    if (index >= 0) {
      _profiles[index] = profile;
    } else {
      _profiles.add(profile);
    }
  }
}
