import '../../../utils/utils.dart';
import '../../database/database.dart';
import '../../services/local_data_service.dart';
import 'profile_repository.dart';

class ProfileRepositoryLocal implements ProfileRepository {
  ProfileRepositoryLocal({required final LocalDataService localDataService})
    : _localDataService = localDataService;

  final LocalDataService _localDataService;

  @override
  Future<Result<Profile>> getDefaultProfile() {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> saveProfile({
    required String name,
    String? description,
  }) {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> removeProfile({required Id profileId}) {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Stream<List<Profile>> watchProfiles() {
    return _localDataService.watchProfiles();
  }
}
