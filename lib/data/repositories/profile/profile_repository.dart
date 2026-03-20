import '../../../utils/utils.dart';
import '../../database/database.dart';

abstract class ProfileRepository {
  Future<Result<Profile>> getDefaultProfile();

  Future<Result<void>> saveProfile({
    required final String name,
    final String? description,
  });

  Future<Result<void>> removeProfile({required final Id profileId});

  Stream<List<Profile>> watchProfiles();
}
