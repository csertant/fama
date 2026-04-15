import '../../../utils/utils.dart';
import '../../database/database.dart';

abstract class ProfileRepository {
  Future<Result<int>> getDatabaseSize();

  Future<Result<Profile>> getDefaultProfile();

  Stream<List<Profile>> watchProfiles();

  Future<Result<void>> saveProfile({
    required final String name,
    final String? description,
  });

  Future<Result<void>> modifyProfile({required final Profile profile});

  Future<Result<void>> removeProfile({required final Id profileId});
}
