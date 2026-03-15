import '../../services/local_data_service.dart';
import 'profile_repository.dart';

class ProfileRepositoryLocal extends ProfileRepository {
  ProfileRepositoryLocal({required final LocalDataService localDataService})
    : _localDataService = localDataService;

  final LocalDataService _localDataService;
}
