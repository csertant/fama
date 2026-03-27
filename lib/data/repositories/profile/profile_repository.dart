import '../../../utils/utils.dart';
import '../../database/database.dart';

abstract class ProfileRepository {
  Future<Result<Profile>> getDefaultProfile();

  Stream<List<Profile>> watchProfiles();

  Future<Result<void>> saveProfile({
    Id? profileId,
    required final String name,
    final String? description,
  });

  Future<Result<void>> removeProfile({required final Id profileId});
}
