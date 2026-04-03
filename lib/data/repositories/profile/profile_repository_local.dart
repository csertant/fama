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
    required String name,
    String? description,
  }) {
    final profile = ProfilesCompanion.insert(
      name: name.trim(),
      description: description != null && description.trim().isNotEmpty
          ? Value(description.trim())
          : const Value.absent(),
    );
    return _localDataService.saveProfile(profile: profile);
  }

  @override
  Future<Result<void>> modifyProfile({required Profile profile}) async {
    final defaultProfileResult = await _localDataService.getDefaultProfile();
    switch (defaultProfileResult) {
      case Ok<Profile>(value: final defaultProfile):
        if (defaultProfile.id != profile.id && profile.isDefault) {
          final demoteResult = await _localDataService.saveProfile(
            profile: defaultProfile
                .toCompanion(true)
                .copyWith(isDefault: const Value(false)),
          );
          switch (demoteResult) {
            case Ok<void>():
              break;
            case Error<void>(error: final demoteError):
              return Result.error(
                LocalDataStorageException(
                  'Failed to demote existing default profile',
                  cause: demoteError,
                ),
              );
          }
        }
        final promoteResult = await _localDataService.saveProfile(
          profile: profile.toCompanion(true),
        );
        switch (promoteResult) {
          case Ok<void>():
            return const Result.ok(null);
          case Error<void>(error: final promoteError):
            return Result.error(
              LocalDataStorageException(
                'Failed to save modified profile',
                cause: promoteError,
              ),
            );
        }
      case Error<Profile>():
        return Result.error(
          LocalDataNotFoundException('Failed to retrieve default profile'),
        );
    }
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
