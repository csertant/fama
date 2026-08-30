import '../../../utils/utils.dart';
import '../../database/database.dart';

abstract class ProfileRepository {
  Future<Result<int>> getDatabaseSize();

  Future<Result<Profile>> getDefaultProfile();

  Stream<List<Profile>> watchProfiles();

  Future<Result<void>> saveProfile({required String name, String? description});

  Future<Result<void>> modifyProfile({required Profile profile});

  Future<Result<void>> removeProfile({required Id profileId});
}
