import 'package:flutter/material.dart';

import '../../data/repositories/profile/profile_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({required ProfileRepository profileRepository})
    : _profileRepository = profileRepository;

  final ProfileRepository _profileRepository;
}
