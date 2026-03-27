import 'package:drift/drift.dart';

import '../../../utils/utils.dart';
import '../../database/database.dart';
import '../../services/local_data_service/local_data_service.dart';
import 'profile_repository.dart';

class ProfileRepositoryLocal implements ProfileRepository {
  ProfileRepositoryLocal({required final LocalDataService localDataService})
    : _localDataService = localDataService;

  final LocalDataService _localDataService;

  static final defaultProfile = ProfilesCompanion.insert(
    name: 'Default Profile',
    isDefault: const Value(true),
  );

  @override
  Future<Result<Profile>> getDefaultProfile() async {
    final result = await _localDataService.getDefaultProfile();
    switch (result) {
      case Ok<Profile>():
        return result;
      case Error<Profile>(error: final error):
        if (error is LocalDataNotFoundException) {
          final saveResult = await _localDataService.saveProfile(
            profile: defaultProfile,
          );
          switch (saveResult) {
            case Ok<void>():
              final newResult = await _localDataService.getDefaultProfile();
              return newResult;
            case Error<void>(error: final saveError):
              return Result.error(
                LocalDataStorageException(
                  'Failed to create default profile',
                  cause: saveError,
                ),
              );
          }
        } else {
          return result;
        }
    }
  }

  @override
  Stream<List<Profile>> watchProfiles() {
    return _localDataService.watchProfiles();
  }

  @override
  Future<Result<void>> saveProfile({
    Id? profileId,
    required String name,
    String? description,
    bool isDefault = false,
  }) {
    final profile = ProfilesCompanion.insert(
      id: profileId != null ? Value(profileId) : const Value.absent(),
      name: name,
      description: Value(description),
      isDefault: Value(isDefault),
    );
    return _localDataService.saveProfile(profile: profile);
  }

  @override
  Future<Result<void>> removeProfile({required Id profileId}) async {
    final profiles = await _localDataService.getProfiles();
    switch (profiles) {
      case Ok<List<Profile>>(value: final profilesList):
        if (profilesList.length <= 1) {
          return Result.error(
            LocalDataStorageException('Cannot delete the only profile'),
          );
        }
        if (profilesList.any((p) => p.id == profileId && p.isDefault)) {
          return Result.error(
            LocalDataStorageException('Cannot delete the default profile'),
          );
        }
      case Error<List<Profile>>(error: final error):
        return Result.error(
          LocalDataStorageException(
            'Failed to retrieve profiles',
            cause: error,
          ),
        );
    }
    return _localDataService.removeProfile(profileId: profileId);
  }
}
